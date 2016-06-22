From: Bastian Arjun Shajit <bastian-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Subject: PROBLEM: Attempting to create subdirectory returns error after
 removing parent directory with child entries using rmdir()
Date: Wed, 22 Jun 2016 16:35:31 +0300
Message-ID: <576A9423.6090505@tuxera.com>
References: <576A9356.2010701@tuxera.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040209000200040109040700"
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <576A9356.2010701-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--------------040209000200040109040700
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

We encountered the following error or unexpected behaviour when
following the steps given below:

1. Mount the remote share exported by either windows or samba using the
following command:
sudo mount -t cifs -o
port=445,vers=2.1,username=<username>,password=password,noperm,actimeo=0
//<IP>/SH1 /mnt/test && cd /mnt/test

2. Run the attached program on the mounted share. You should see the
following output:

**bastian@gutbark-UX32VD:/mnt/test$ /KVMstorage/cifs_dir_bug
** [4428] mkdir ./parentdir 0777
** [4428] mkdir ./parentdir/sub.0 0777
** [4428] chdir ./parentdir/sub.0
** [4428] rmdir /mnt/test/parentdir
!! [4428] stat() /mnt/test/parentdir Success
** [4428] mkdir /mnt/test/parentdir/sub.1
!! [4428] mkdir /mnt/test/parentdir/sub.1 failed(No such file or directory)

You can see from the above logs, stat of parentdir is successful but
creating a new child directory under the parent fails.

The attached program does the following:
a. Create a parent directory
b. Create a sub-directory under the parent.
c. Change dir to sub-directory
d. Now delete the parent directory using absolute path from the cifs
client using "rmdir".

The POSIX behaviour for rmdir() is that if there are entries other than
"." and ".." it must return ENOTEMPTY error. But as per SMB2 protocol
specification, we delete a directory by:
a. Open directory with "Delete on Close" Flag set in the "CreateOptions"
field of the SMB2 CREATE request.
b. Close the open handle returned in the response for the previous request.

As per SMB2 specification, the SMB2 close will always return NT status
STATUS_SUCCESS for removing the directory even if the directory has
child entries, but the server does not delete the directory itself.

4. Manually running "tree" on the mounted share shows the following:
bastian@gutbark-UX32VD:/mnt/test$ tree
.
|__parentdir
1 directory, 0 files

We clearly see above that the parent directory does not show any child
directories.

5.Now we unmount and mount the remote share again
bastian@gutbark-UX32VD:/mnt/test$ cd / && sudo umount /mnt/test
bastian@gutbark-UX32VD:/KVMstorage/$ sudo mount -t cifs -o
port=445,vers=2.1,username=<Username>,password=password,noperm,actimeo=0
//<IP>/SH1 /mnt/test && cd /mnt/test
bastian@gutbark-UX32VD:/mnt/test$ tree
.
|__parentdir
            |__ sub.0
2 directories, 0 files//

As you can see, remounting the remote share now displays a subdirectory
which was not displayed in the earlier mount cycle.

We used the following test setup for reproducing the above said issue:
1. Cifs client: Version = 2.06, Linux versions: Ubuntu, 3.19.8-ckt5 &
3.16.0-49-generic
2. Server: Windows 8.1 pro, Windows 7, Samba 4.1.6-Ubuntu.
3. Reproducible only on SMB2 protocol version.

The issue was reproducible always on WIndows SMB server whereas on Samba
server we were able to reproduce 1/2 times.

We ran the same tests on CIFS client version: 2.08, Linux versions 4.4
and 4.5 and we were unable to reproduce the issue.

Br,
Bastian


--------------040209000200040109040700
Content-Type: text/x-csrc; name="cifs_dir_bug.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cifs_dir_bug.c"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>


static int dirbug();

int
main(int argc, char *argv[])
{
    return (dirbug());
}

#define MAX_TEST_PATH_LEN   1024

int dirbug()
{
    int         error;
    int         pid = getpid();
    struct stat st;
    long        len;
    char        *buf = NULL;
    char        *cwd = NULL;
    
    len = pathconf(".", _PC_PATH_MAX);
    if (((cwd = (char *)malloc((size_t)len)) == NULL) ||
        ((buf = (char *)malloc((size_t)len + MAX_TEST_PATH_LEN)) == NULL))
    {
        fprintf(stderr, "No memory to place current working dir (Err : %s)\n",
                        strerror(errno));
        goto err;
    }
    getcwd(cwd, len);

    sprintf(buf, "./parentdir");
    fprintf(stderr, "** [%d] mkdir %s 0777\n", pid, buf);
    error = mkdir(buf, 0777);
    if (error && (errno != EEXIST))
    {
        fprintf(stderr, "!! [%d] mkdir %s failed(%s)\n", pid, buf,
                                                         strerror(errno));
        goto err;
    }

    sprintf(buf, "./parentdir/sub.0");
    fprintf(stderr, "** [%d] mkdir %s 0777\n", pid, buf);
    error = mkdir(buf, 0777);
    if (error && (errno != EEXIST)) {
        fprintf(stderr, "!! [%d] mkdir %s failed(%s)\n", pid, buf,
                                                         strerror(errno));
        goto err;
    }
    fprintf(stderr, "** [%d] chdir %s\n", pid, buf);
    error = chdir(buf);
    if (error) {
        fprintf(stderr, "!! [%d] chdir %s failed(%s)\n", pid, buf,
                                                        strerror(errno));
        goto err;;
    }

    sprintf(buf, "%s/parentdir", cwd);
    fprintf(stderr, "** [%d] rmdir %s\n", pid, buf);
    if (rmdir(buf))
        fprintf(stderr, "!! [%d] rmdir %s failed(%s)\n", pid, buf,
                                                        strerror(errno));

    errno = 0;
    error = stat(buf, &st);
    fprintf(stderr, "!! [%d] stat() %s %s\n", pid, buf,
                                              strerror(errno));

    sprintf(buf, "%s/parentdir/sub.1", cwd);
    fprintf(stderr, "** [%d] mkdir %s\n", pid, buf);
    error = mkdir(buf, 0777);
    if (error && (errno != EEXIST)) {
        fprintf(stderr, "!! [%d] mkdir %s failed(%s)\n", pid, buf,
                                                        strerror(errno));
        goto err;
    }

    return 0;

err:
    if (cwd)
        free(cwd);
    if (buf)
        free(buf);
    return 1;
}



--------------040209000200040109040700--
