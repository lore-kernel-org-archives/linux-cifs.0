From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Question regarding CIFS cache=loose behavior.
Date: Thu, 20 Mar 2014 21:03:03 +0900
Message-ID: <201403202103.EIE87056.QVtLHSFMFOOFOJ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Is the behavior described below ( "read() returns 0 unless stat() detects the
growth of file size" and "read() returns non-0 when stat() detects the growth
of file size but the data actually read is '\0'" ) a feature of cache=loose
option?

Steps to reproduce:

---------- Start of writer1.c ----------
#include <unistd.h>
int main(int argc, char *argv[])
{
    while (write(1, ".", 1) == 1)
        sleep(1);
    return 0;
}
---------- End of writer1.c ----------

---------- Start of reader1.c ----------
#include <unistd.h>
int main(int argc, char *argv[])
{
    while (1) {
        char c;
        if (read(0, &c, 1) == 1) {
            if (c)
                write(1, &c, 1);
            else
                write(1, "!", 1);
        } else {
            sleep(1);
        }
    }
    return 0;
}
---------- End of reader1.c ----------

---------- Start of reader2.c ----------
#include <sys/stat.h>
#include <unistd.h>
int main(int argc, char *argv[])
{
    while (1) {
        struct stat buf;
        char c;
        fstat(0, &buf);
        if (read(0, &c, 1) == 1) {
            if (c)
                write(1, &c, 1);
            else
                write(1, "!", 1);
        } else {
            sleep(1);
        }
    }
    return 0;
}
---------- End of reader2.c ----------

Run the following commands on the Samba server side.

  $ cc -Wall -O3 -o writer1 writer1.c
  $ ./writer1 > shared_file

Run the following commands on the Samba client side.

  $ cc -Wall -O3 -o reader1 reader1.c
  $ strace -tt -o /tmp/log1 ./reader1 < shared_file
  ..........     (<= Makes no progress by default)

The shared_file shown above is a regular file shared via CIFS mounted with
cache=loose option. (e.g. "mount -t cifs -o cache=loose //server/path /mnt" )

I expect that the reader1 process reads one byte whenever the writer1
process writes one byte. But we can observe via /tmp/log1 that the read()
continues returning 0 until the growth of file size of shared_file is
recognized by stat() using programs like /bin/ls and /usr/bin/stat .

Then, terminate the reader1 process using Ctrl-C and run the following
commands on the Samba client side.

  $ cc -Wall -O3 -o reader2 reader2.c
  $ strace -tt -o /tmp/log2 ./reader2 < shared_file
  ......................!!!!!!     (<= Makes progress with wrong data)

We can observe via /tmp/log2 that the read() returns 1 because fstat()
detects the growth of file size of shared_file . However, the data
returned by read() is not '.' but '\0'.
