From: Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
Date: Sun, 14 Dec 2014 16:54:12 -0800
Message-ID: <CAJiQ=7B5L=ZrJYSCuUDkG+qtUOUHueAwsWut4KyBTsj0xE+q5w@mail.gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
 <CAJiQ=7C9qV2acVLWjacwsRmGMbyKUqCT5VbnO5TzeLLX73xMaQ@mail.gmail.com>
 <CAH2r5mteTRPVNTgVxNLqjdzok87HXxhC+xo+tnR3L0DKntSe6g@mail.gmail.com>
 <CAJiQ=7APtRLarnAFFaDy1_KgnBN-wcK2=scOP5Ks0v5GH=AR3Q@mail.gmail.com> <CAH2r5mucwo_FH4M=UUoLNDZNRFFcG9hd=Gxc7ma5jwkJQ2-qTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mucwo_FH4M=UUoLNDZNRFFcG9hd=Gxc7ma5jwkJQ2-qTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Dec 14, 2014 at 4:28 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Sat, Dec 13, 2014 at 11:29 PM, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>> On Sat, Dec 13, 2014 at 9:20 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>> Probably harmless patch - but I didn't notice the warning on x86
>>> kernel build (building on Fedora 21, gcc 4.9.2)
>>
>> Did you test x86 32-bit or 64-bit?  In the generic do_div()
>
> I built current mainline with 64 bit disabled. No warnings on this
> before or after the patch.

Ah, right, it only shows up on 32-bit architectures that use the
generic do_div implementation.  To see the warning on x86, you'd need
to do something like this:

$ git --no-pager diff
diff --git a/arch/x86/include/asm/div64.h b/arch/x86/include/asm/div64.=
h
index ced283a..f693002 100644
--- a/arch/x86/include/asm/div64.h
+++ b/arch/x86/include/asm/div64.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_DIV64_H
 #define _ASM_X86_DIV64_H

-#ifdef CONFIG_X86_32
+#if 0//def CONFIG_X86_32

 #include <linux/types.h>
 #include <linux/log2.h>
$ touch fs/cifs/netmisc.c
$ make ARCH=3Dx86 vmlinux
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      fs/cifs/netmisc.o
fs/cifs/netmisc.c: In function =E2=80=98cifs_NTtimeToUnix=E2=80=99:
fs/cifs/netmisc.c:937:23: warning: comparison of distinct pointer
types lacks a cast [enabled by default]
fs/cifs/netmisc.c:941:22: warning: comparison of distinct pointer
types lacks a cast [enabled by default]
  LD      fs/cifs/cifs.o
  LD      fs/cifs/built-in.o
  LD      fs/built-in.o
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
$


> merged into cifs-2.6.git

Thanks!
