From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Tue, 26 Oct 2010 10:46:31 +0530
Message-ID: <4CC6642F.2040401@suse.de>
References: <4CC65859.7040100@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC65859.7040100-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/26/2010 09:56 AM, Shinnosuke Yagi wrote:
> Dear.
> 
> Now, I try to use mount.smb2, which was posted at
> http://archives.free.net.ph/message/20100507.172615.fda263bc.en.html
> 
> However, mount.smb2 was failed with error message.
> 
>  mount error: smb2 filesystem not supported by the system
> 
> So, I need a source code of smb2 kernel module.
> (Test or experimental branch will do, because I know smb2
>  is not in mainline kernels.)
> 
> I tried to do
> "git clone
> http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/sfrench/smb2.git"
> to find it failed.
> 
> Are there another git repository (or any patch) ?
> 

Try doing:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/smb2.git


-- 
Suresh Jayaraman
