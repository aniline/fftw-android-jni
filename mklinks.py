#!python

import os, sys, glob

if (len(sys.argv) <= 1):
    print "Error: Pass the top level build directory as argument."
    sys.exit(1)

top_dir = sys.argv[1]
jni_dir = os.path.normpath(top_dir + '/jni')
mk_dirs = ['kernel', 'dft', 'dft/scalar', 'dft/scalar/codelets', 'rdft', 'rdft/scalar', 'rdft/scalar/r2cf', 'rdft/scalar/r2cb', 'rdft/scalar/r2r', 'reodft', 'api', 'tests', 'libbench2', 'threads']

count_error = { 'dir' : 0, 'file' : 0 };

for n in mk_dirs:
    n_n = os.path.normpath(top_dir + '/' + n)
    t_path = os.path.normpath(jni_dir + '/' + os.path.relpath(n_n, top_dir))
    try:
        os.mkdir(t_path);
    except OSError, e:
        count_error['dir'] = count_error['dir'] + 1
        # print '"'+t_path + '": ' + e.strerror
    for m in glob.glob(n_n + '/*.[ch]'):
        link_name = os.path.normpath(jni_dir + '/' + os.path.relpath(m, top_dir))
        rel_target = os.path.relpath(m, os.path.dirname(link_name))
        try:
            # TODO: Windows.
            os.symlink(rel_target, link_name)
        except OSError, e:
            count_error['file'] = count_error['file'] + 1
            # print '"' + link_name + '": ' + e.strerror

# config.h
try:
    # TODO: Windows.
    os.symlink(os.path.relpath(os.path.normpath(top_dir + '/config.h'), jni_dir), os.path.normpath(jni_dir + '/config.h'))
except OSError, e:
    count_error['file'] = count_error['file'] + 1

print 'Errors on ', count_error
