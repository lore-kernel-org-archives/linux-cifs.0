From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Wed, 27 Oct 2010 12:31:26 -0500
Message-ID: <1288200686.3764.55.camel@calx>
References: <1287428685.16450.282.camel@calx>  <4CBD6843.3060702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBD6843.3060702-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2010-10-19 at 15:13 +0530, Suresh Jayaraman wrote:
> On 10/19/2010 12:34 AM, Matt Mackall wrote:
> > With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
> > hardlink counts can mysteriously disappear:
> > 
> > - create hardlink pair foo,bar
> > - stat foo -> nlink = 2
> > - open foo
> > - stat foo -> nlink = 1
> > - close
> > - wait or sync
> > - ls -l -> nlink = 2
> > 
> > Original report is here:
> > 
> > http://mercurial.selenic.com/bts/issue1866
> > 
> 
> A quick test on 2.6.36-rc4 kernel reveals that the problem is no longer
> reproducible. Could you try a more recent kernel and see whether the
> problem is reproducible?

Test continues to fail with 2.6.36.

# uname -a
Linux calx 2.6.36 #71 SMP Tue Oct 26 02:23:34 CDT 2010 x86_64 GNU/Linux
# mount -o nounix //localhost/stuff cifs
           ^^^^^^
# cd cifs
# touch foo
# ln foo bar
# ./h
file: foo nlinks 2
file: foo nlinks 1
file: foo nlinks 1

# cat h.c
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

#define FPATH "foo"

int main(void)
{
	int rc, fh;
	struct stat st;

	rc = lstat(FPATH, &st);
	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);

	fh = open(FPATH, 0, O_RDONLY);

	rc = lstat(FPATH, &st);
	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);

	close(fh);

	rc = lstat(FPATH, &st);
	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);

	return 0;
}




-- 
Mathematics is the supreme nostalgia of our time.
