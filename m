From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Fri, 29 Oct 2010 12:32:15 +0530
Message-ID: <4CCA7177.40303@suse.de>
References: <4CC65859.7040100@nttcom.co.jp> <4CC6642F.2040401@suse.de> <4CCA6FD3.4060907@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CCA6FD3.4060907-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/29/2010 12:25 PM, Shinnosuke Yagi wrote:
> Thank you, Suresh.
> 
> I could get kernel source.
> Then, I try to build with following SMB2 options.
> 
> ==========================================
> $ grep SMB2 .config
> CONFIG_SMB2_FS=y
> # CONFIG_SMB2_STATS is not set
> # CONFIG_SMB2_DEBUG2 is not set
> ==========================================
> 
> 
> However, I failed to build and got a following error.
> 
> ====================================================
> $ make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
>   LD      fs/built-in.o
> ld: fs/cifs_common/built-in.o: No such file: No such file or directory
> make[1]: *** [fs/built-in.o] Error 1
> make: *** [fs] Error 2
> =====================================================
> 

Just comment out the line

obj-$(CONFIG_CIFS_COMMON)       += cifs_common/

in fs/Makefile and try. Seems Steve's fix is still missing in the smb2.git.


-- 
Suresh Jayaraman
