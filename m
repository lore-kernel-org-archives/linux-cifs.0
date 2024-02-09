Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF4656B89;
	Fri,  9 Feb 2024 05:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707456923; cv=none; b=WTmV5wY1Qo2yB9WmQyz0NzCScBFPSxov7s0ClruPnjpnkdCzx+WlXWydJeBHWmpzqVX2WSlmU2Qt3JxKm4ttahWsxEdSe+gcxdNONWe57PDhbibmKg9tqP12W3S+l4ChC6h4tunCDrkNLMQluXPJdpCYLdSCw9P1eh4nk2HeHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707456923; c=relaxed/simple;
	bh=C6tBVERpdTIuhzfp5Ou9UKsbTwdksnhIal55frNHhk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t/ogXdt9hoyRJJgw1vzVigGWjBt6j25usQqa9pVEd3f4L0KCNOvIoqEGYRJVoZsbHqLiufue+nQPPq3EC3nam7Akf355kcB6uy3ir4p+MLn/KJMVgxQjDLh5x3FBh+Vyaqm+BetnTPNEpZkCTipa6YFWo79VKv1qIOqxgogRHGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gkNWQBt0; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkNWQBt0"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51168addef1so1026156e87.1;
        Thu, 08 Feb 2024 21:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707456919; x=1708061719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTj8SSHvn0ZHFXcMz6w6muyxECXQg/MQZZumRAAuc8U=;
        b=gkNWQBt0lKxLS7a/qfw8EU6PLjTCpkC8G4jX7kSxP/kkQDgyrJgMzq3HAWEI6HhfCA
         939Sj649fAdGxCa158kxSM7RvpqEeiwdSrsbPcX4UqAVJgce179ANya6FxSbsNboulYD
         iVDp5bU+hvZpsUfK5zI7+VNhIaSkQwn/mqcXUk9Jy3LR6EspWv1Vb/kd5Agz+xn/hYS5
         ydww2NcmpG3F3zJrXHAB2KitgEQ1TUXNz7rSkC3lQ3s46HYimrt4hpuJLdgoHhIgaqBR
         ztzE3k9boyjDHYwQkr0icQDm6q532udMJwAkVcDLZFjVUIi5aTvlT0Cw/sVC/z/gRb6d
         ivkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707456919; x=1708061719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTj8SSHvn0ZHFXcMz6w6muyxECXQg/MQZZumRAAuc8U=;
        b=NYR0iGw7J+bTbIj0P8GZs2+9tu+gEpBHfowvbvZPoNw3GWuPyiHzTWkjtZGf0Y5YEI
         jMYBhrA2PwS/3v0VDXE9ezoanDeBGJjWLG4PBvwEmfgbawVYl1FQOY1yWrjFZ53era1T
         mbuH9KTLYOCgGR7RyS8XCcpDv2eLefgukN/izjqZ+xCiTBn32Nx0ErPfLTz15tzdDmM6
         OqWN9rqqFzRSxDi2n4ITvsQosiqbv9Gtb+pFFPEnqMSI/LihdN0qlfz+/gU7c0EsnobE
         el99IuvKoPDz9u2utMQWgLDpOzQokYpAlJ1v0qliY1FDt5zejnr5A4ZRj7uqqxNsPgDw
         htBA==
X-Gm-Message-State: AOJu0YzTyZ796VhKwwlD6ZjOAcoszg8Fy4aaoz0ZObfXxx4BdStL9DxT
	arzT0T+yT5OcLh+FIpRVTAgUsdQ5jAQ2czm01fXRH/MDSyfO9ZLgKEc+eiyJ+uGc+PvSwriOSc4
	UdRv91b6QizppklJBaInGp3eoYD8+rrfwywQ=
X-Google-Smtp-Source: AGHT+IHa/oG8fyHbaD6W3os8lSXtf3mjiqoUoTLMxqjb3mz47Esh+GHtIX7HR1zaeD8vSGgkZve7vsrey14N/L+coDE=
X-Received: by 2002:ac2:495a:0:b0:511:4ff0:5328 with SMTP id
 o26-20020ac2495a000000b005114ff05328mr269374lfi.32.1707456918483; Thu, 08 Feb
 2024 21:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230925201827.1703857-1-aahringo@redhat.com> <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 8 Feb 2024 23:35:06 -0600
Message-ID: <CAH2r5msWwX7QdXrzmR3tapU85WMga9Y-waNOHm+hMWmWPUF=tQ@mail.gmail.com>
Subject: Re: [PATCHv2] generic: add fcntl corner cases tests
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Aring <aahringo@redhat.com>, fstests@vger.kernel.org, gfs2@lists.linux.dev, 
	jlayton@kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Could you forward the changeset for this so we could try it?

On Thu, Feb 8, 2024 at 11:26=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Sep 25, 2023 at 04:18:27PM -0400, Alexander Aring wrote:
> > This patch adds fcntl corner cases that was being used to confirm issue=
s
> > on a GFS2 filesystem. The GFS2 filesystem has it's own ->lock()
> > implementation and in those corner cases issues was being found and
> > fixed.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
>
> Hi Alexander,
>
> This test case directly hang on CIFS testing. Actually it's not a
> real hang, the fcntl_lock_corner_tests process can be killed, but
> before killing it manually, it was blocked there.
>
> Please check if it's a case issue or cifs bug, or it's not suitable
> for cifs? I'll try to delay this patch merging to next release,
> leave some time to have a discission. CC cifs list to get more
> reviewing.
>
> Thanks,
> Zorro
>
> FSTYP         -- cifs
> PLATFORM      -- Linux/ppc64le ibm-xxx-xxx-xxxx 6.8.0-rc3+ #1 SMP Wed Feb=
  7 01:38:35 EST 2024
> MKFS_OPTIONS  -- //xxx-xxx-xx-xxxx.xxxx.xxx.com/SCRATCH_dev
> MOUNT_OPTIONS -- -o vers=3D3.11,mfsymlinks,username=3Droot,password=3Dred=
hat -o context=3Dsystem_u:object_r:root_t:s0 //xxx-xxx-xx-xxxx.xxxx.xxx.com=
/SCRATCH_dev /mnt/xfstests/scratch/cifs-client
>
> generic/740
> ...
> ...
>
> # ps axu|grep fcntl
> root     1138909  0.0  0.0   5056     0 ?        S    Feb07   0:00 /var/l=
ib/xfstests/src/fcntl_lock_corner_tests /mnt/xfstests/test/cifs-client/test=
file
> root     1138910  0.0  0.0  21760     0 ?        Sl   Feb07   0:00 /var/l=
ib/xfstests/src/fcntl_lock_corner_tests /mnt/xfstests/test/cifs-client/test=
file
> # cat /proc/1138909/stack
> [<0>] 0xc00000008d068a00
> [<0>] __switch_to+0x13c/0x228
> [<0>] do_wait+0x15c/0x224
> [<0>] kernel_wait4+0xb8/0x2c8
> [<0>] system_call_exception+0x134/0x390
> [<0>] system_call_vectored_common+0x15c/0x2ec
> # cat /proc/1138910/stack
> [<0>] 0xc00000008de94400
> [<0>] __switch_to+0x13c/0x228
> [<0>] futex_wait_queue+0xa8/0x134
> [<0>] __futex_wait+0xb4/0x15c
> [<0>] futex_wait+0x94/0x150
> [<0>] do_futex+0xe8/0x374
> [<0>] sys_futex+0xa4/0x234
> [<0>] system_call_exception+0x134/0x390
> [<0>] system_call_vectored_common+0x15c/0x2ec
>
> # strace -p 1138909
> strace: Process 1138909 attached
> wait4(-1,
> (nothing more output)
> strace: Process 1138909 detached
> ^C <detached ...>
> # strace -p 1138910
> strace: Process 1138910 attached
> futex(0x7fff97a8f110, FUTEX_WAIT_BITSET|FUTEX_CLOCK_REALTIME, 1138912, NU=
LL, FUTEX_BITSET_MATCH_ANY
> (nothing more output)
> ^Cstrace: Process 1138910 detached
>  <detached ...>
>
>
> > changes since v2:
> > - move fcntl tests into one fcntl c file
> > - remove ofd and same owner tests, should be reflected by only one test
> > - simplify commit message (remove testname out of it)
> > - add error messages in fcntl.c to give more information if an error
> >   occur
> >
> >  src/Makefile          |   3 +-
> >  src/fcntl.c           | 322 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/732     |  32 +++++
> >  tests/generic/732.out |   2 +
> >  4 files changed, 358 insertions(+), 1 deletion(-)
> >  create mode 100644 src/fcntl.c
> >  create mode 100755 tests/generic/732
> >  create mode 100644 tests/generic/732.out
> >
> > diff --git a/src/Makefile b/src/Makefile
> > index 2815f919..67f936d3 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -19,7 +19,8 @@ TARGETS =3D dirstress fill fill2 getpagesize holes ls=
tat64 \
> >       t_ofd_locks t_mmap_collision mmap-write-concurrent \
> >       t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
> >       t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale=
 \
> > -     t_mmap_cow_memory_failure fake-dump-rootino dio-buf-fault rewindd=
ir-test
> > +     t_mmap_cow_memory_failure fake-dump-rootino dio-buf-fault rewindd=
ir-test \
> > +     fcntl
> >
> >  LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize preallo_rw_pattern=
_reader \
> >       preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> > diff --git a/src/fcntl.c b/src/fcntl.c
> > new file mode 100644
> > index 00000000..8e375357
> > --- /dev/null
> > +++ b/src/fcntl.c
> > @@ -0,0 +1,322 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/* Copyright (c) 2023 Alexander Aring.  All Rights Reserved.
> > + */
> > +
> > +#include <pthread.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +#include <limits.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <wait.h>
> > +
> > +static char filename[PATH_MAX + 1];
> > +static int fd;
> > +
> > +static void usage(char *name, const char *msg)
> > +{
> > +     printf("Fatal: %s\nUsage:\n"
> > +            "%s <file for fcntl>\n", msg, name);
> > +     _exit(1);
> > +}
> > +
> > +static void *do_equal_file_lock_thread(void *arg)
> > +{
> > +       struct flock fl =3D {
> > +            .l_type =3D F_WRLCK,
> > +            .l_whence =3D SEEK_SET,
> > +            .l_start =3D 0L,
> > +            .l_len =3D 1L,
> > +       };
> > +       int rv;
> > +
> > +       rv =3D fcntl(fd, F_SETLKW, &fl);
> > +       if (rv =3D=3D -1) {
> > +            perror("fcntl");
> > +            _exit(1);
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +static void do_test_equal_file_lock(void)
> > +{
> > +     struct flock fl;
> > +     pthread_t t[2];
> > +     int pid, rv;
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0L;
> > +     fl.l_len =3D 1L;
> > +
> > +     /* acquire range 0-0 */
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +            perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     pid =3D fork();
> > +     if (pid =3D=3D 0) {
> > +             rv =3D pthread_create(&t[0], NULL, do_equal_file_lock_thr=
ead, NULL);
> > +             if (rv !=3D 0) {
> > +                     fprintf(stderr, "failed to create pthread\n");
> > +                     _exit(1);
> > +             }
> > +
> > +             rv =3D pthread_create(&t[1], NULL, do_equal_file_lock_thr=
ead, NULL);
> > +             if (rv !=3D 0) {
> > +                     fprintf(stderr, "failed to create pthread\n");
> > +                     _exit(1);
> > +             }
> > +
> > +             pthread_join(t[0], NULL);
> > +             pthread_join(t[1], NULL);
> > +
> > +             _exit(0);
> > +     }
> > +
> > +     /* wait until threads block on 0-0 */
> > +     sleep(3);
> > +
> > +     fl.l_type =3D F_UNLCK;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     sleep(3);
> > +
> > +     /* check if the ->lock() implementation got the
> > +      * right locks granted because two waiter with the
> > +      * same file_lock fields are waiting
> > +      */
> > +     fl.l_type =3D F_WRLCK;
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1 && errno =3D=3D EAGAIN) {
> > +             fprintf(stderr, "deadlock, pthread not cleaned up correct=
ly\n");
> > +             _exit(1);
> > +     }
> > +
> > +     wait(NULL);
> > +}
> > +
> > +static void catch_alarm(int num) { }
> > +
> > +static void do_test_signal_interrupt_child(int *pfd)
> > +{
> > +     struct sigaction act;
> > +     unsigned char m;
> > +     struct flock fl;
> > +     int rv;
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 1;
> > +     fl.l_len =3D 1;
> > +
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     memset(&act, 0, sizeof(act));
> > +     act.sa_handler =3D catch_alarm;
> > +     sigemptyset(&act.sa_mask);
> > +     sigaddset(&act.sa_mask, SIGALRM);
> > +     sigaction(SIGALRM, &act, NULL);
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     /* interrupt SETLKW by signal in 3 secs */
> > +     alarm(3);
> > +     rv =3D fcntl(fd, F_SETLKW, &fl);
> > +     if (rv =3D=3D 0) {
> > +             fprintf(stderr, "fcntl interrupt successful but should fa=
il with EINTR\n");
> > +             _exit(1);
> > +     }
> > +
> > +     /* synchronize to move parent to test region 1-1 */
> > +     write(pfd[1], &m, sizeof(m));
> > +
> > +     /* keep child alive */
> > +     read(pfd[1], &m, sizeof(m));
> > +}
> > +
> > +static void do_test_signal_interrupt(void)
> > +{
> > +     struct flock fl;
> > +     unsigned char m;
> > +     int pid, rv;
> > +     int pfd[2];
> > +
> > +     rv =3D pipe(pfd);
> > +     if (rv =3D=3D -1) {
> > +             perror("pipe");
> > +             _exit(1);
> > +     }
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     pid =3D fork();
> > +     if (pid =3D=3D 0) {
> > +             do_test_signal_interrupt_child(pfd);
> > +             _exit(0);
> > +     }
> > +
> > +     /* wait until child writes */
> > +     read(pfd[0], &m, sizeof(m));
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 1;
> > +     fl.l_len =3D 1;
> > +     /* parent testing childs region, the child will think
> > +      * it has region 1-1 locked because it was interrupted
> > +      * by region 0-0. Due bugs the interruption also unlocked
> > +      * region 1-1.
> > +      */
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D 0) {
> > +             fprintf(stderr, "fcntl trylock successful but should fail=
 because child still acquires region\n");
> > +             _exit(1);
> > +     }
> > +
> > +     write(pfd[0], &m, sizeof(m));
> > +
> > +     wait(NULL);
> > +
> > +     close(pfd[0]);
> > +     close(pfd[1]);
> > +
> > +     /* cleanup everything */
> > +     fl.l_type =3D F_UNLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 2;
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +}
> > +
> > +static void do_test_kill_child(void)
> > +{
> > +     struct flock fl;
> > +     int rv;
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     rv =3D fcntl(fd, F_SETLKW, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +}
> > +
> > +static void do_test_kill(void)
> > +{
> > +     struct flock fl;
> > +     int pid_to_kill;
> > +     int rv;
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     pid_to_kill =3D fork();
> > +     if (pid_to_kill =3D=3D 0) {
> > +             do_test_kill_child();
> > +             _exit(0);
> > +     }
> > +
> > +     /* wait until child blocks */
> > +     sleep(3);
> > +
> > +     kill(pid_to_kill, SIGKILL);
> > +
> > +     /* wait until Linux did plock cleanup */
> > +     sleep(3);
> > +
> > +     fl.l_type =3D F_UNLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     /* cleanup parent lock */
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if (rv =3D=3D -1) {
> > +             perror("fcntl");
> > +             _exit(1);
> > +     }
> > +
> > +     fl.l_type =3D F_WRLCK;
> > +     fl.l_whence =3D SEEK_SET;
> > +     fl.l_start =3D 0;
> > +     fl.l_len =3D 1;
> > +
> > +     /* check if the child still holds the lock
> > +      * and killing the child was not cleaning
> > +      * up locks.
> > +      */
> > +     rv =3D fcntl(fd, F_SETLK, &fl);
> > +     if ((rv =3D=3D -1 && errno =3D=3D EAGAIN)) {
> > +             fprintf(stderr, "fcntl trylock failed but should be succe=
ssful because killing child should cleanup acquired lock\n");
> > +             _exit(1);
> > +     }
> > +}
> > +
> > +int main(int argc, char * const argv[])
> > +{
> > +     if (optind !=3D argc - 1)
> > +             usage(argv[0], "<file for fcntl> is mandatory to tell the=
 file where to run fcntl() on it");
> > +
> > +     strncpy(filename, argv[1], PATH_MAX);
> > +
> > +     fd =3D open(filename, O_RDWR | O_CREAT, 0700);
> > +     if (fd =3D=3D -1) {
> > +             perror("open");
> > +             _exit(1);
> > +     }
> > +
> > +     /* test to have to equal struct file_lock requests in ->lock() */
> > +     do_test_equal_file_lock();
> > +     /* test to interrupt F_SETLKW by a signal and cleanup only cancel=
ed the pending interrupted request */
> > +     do_test_signal_interrupt();
> > +     /* test if cleanup is correct if a child gets killed while being =
blocked in F_SETLKW */
> > +     do_test_kill();
> > +
> > +     close(fd);
> > +
> > +     return 0;
> > +}
> > diff --git a/tests/generic/732 b/tests/generic/732
> > new file mode 100755
> > index 00000000..d77f9fc2
> > --- /dev/null
> > +++ b/tests/generic/732
> > @@ -0,0 +1,32 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Alexander Aring.  All Rights Reserved.
> > +#
> > +# FS QA Test 732
> > +#
> > +# This tests performs some fcntl() corner cases. See fcntl test
> > +# program for more details.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_test
> > +_require_test_program fcntl
> > +
> > +echo "Silence is golden"
> > +
> > +$here/src/fcntl $TEST_DIR/testfile
> > +if [ $? -ne 0 ]
> > +then
> > +     exit
> > +fi
> > +
> > +status=3D0
> > +exit
> > diff --git a/tests/generic/732.out b/tests/generic/732.out
> > new file mode 100644
> > index 00000000..451f82ce
> > --- /dev/null
> > +++ b/tests/generic/732.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 732
> > +Silence is golden
> > --
> > 2.31.1
> >
>
>


--=20
Thanks,

Steve
