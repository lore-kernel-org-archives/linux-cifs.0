From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Fri, 29 Oct 2010 15:55:15 +0900
Message-ID: <4CCA6FD3.4060907@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp> <4CC6642F.2040401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC6642F.2040401-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you, Suresh.

I could get kernel source.
Then, I try to build with following SMB2 options.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ grep SMB2 .config
CONFIG_SMB2_FS=3Dy
# CONFIG_SMB2_STATS is not set
# CONFIG_SMB2_DEBUG2 is not set
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


However, I failed to build and got a following error.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
$ make
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
   VDSOSYM arch/x86/vdso/vdso32-syms.lds
   LD      arch/x86/vdso/built-in.o
   LD      arch/x86/built-in.o
   LD      fs/built-in.o
ld: fs/cifs_common/built-in.o: No such file: No such file or directory
make[1]: *** [fs/built-in.o] Error 1
make: *** [fs] Error 2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

It seems that files in fs/cifs_common/ are lost.

In fact, fs/cifs_common is empty.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
$ ls -al fs/cifs_common/
=E5=90=88=E8=A8=88 16
drwxr-xr-x  2 xxxx xxxx  4096 2010-10-29 15:33 .
drwxr-xr-x 74 xxxx xxxx 12288 2010-10-29 15:42 ..
-rw-r--r--  1 xxxx xxxx     0 2010-10-27 11:00 Makefile
-rw-r--r--  1 xxxx xxxx     0 2010-10-29 15:42 modules.order
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I also failed to bulid with no SMB2 options.


What should I do?



Thanks.


(2010/10/26 14:16), Suresh Jayaraman wrote:
> On 10/26/2010 09:56 AM, Shinnosuke Yagi wrote:
>> Dear.
>>
>> Now, I try to use mount.smb2, which was posted at
>> http://archives.free.net.ph/message/20100507.172615.fda263bc.en.html
>>
>> However, mount.smb2 was failed with error message.
>>
>>   mount error: smb2 filesystem not supported by the system
>>
>> So, I need a source code of smb2 kernel module.
>> (Test or experimental branch will do, because I know smb2
>>   is not in mainline kernels.)
>>
>> I tried to do
>> "git clone
>> http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/sfrench/smb2=
=2Egit"
>> to find it failed.
>>
>> Are there another git repository (or any patch) ?
>>
>
> Try doing:
>
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/smb2.=
git
>
>


--=20
-------------------------------------
=E5=85=AB=E6=9C=A8 =E6=B8=85=E4=B9=8B=E4=BB=8B =EF=BC=88=E3=83=A4=E3=82=
=AE=E3=80=80=E3=82=B7=E3=83=B3=E3=83=8E=E3=82=B9=E3=82=B1=EF=BC=89
NTT=E3=82=B3=E3=83=A0=E3=82=A6=E3=82=A7=E3=82=A2=E6=A0=AA=E5=BC=8F=E4=BC=
=9A=E7=A4=BE
=E3=83=8D=E3=83=83=E3=83=88=E3=83=AF=E3=83=BC=E3=82=AF=E3=83=BB=E3=82=BD=
=E3=83=AA=E3=83=A5=E3=83=BC=E3=82=B7=E3=83=A7=E3=83=B3=E4=BA=8B=E6=A5=AD=
=E6=9C=AC=E9=83=A8
yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org
-------------------------------------
