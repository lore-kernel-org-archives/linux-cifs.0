From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Wed, 03 Nov 2010 14:32:25 +0530
Message-ID: <4CD12521.2020708@suse.de>
References: <4CC65859.7040100@nttcom.co.jp> <4CC6642F.2040401@suse.de> <4CCA6FD3.4060907@nttcom.co.jp> <4CCA7177.40303@suse.de> <4CCF5DF8.9030809@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CCF5DF8.9030809-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/02/2010 06:10 AM, Shinnosuke Yagi wrote:
> Thank you, Suresh.
> 
> I succeeded in building kernel and mount SAMBA share with mount.smb2.
> 
> However, it seems that mount.smb2 works as cifs client
> (NOT works as SMB2 client).
> 
> Mount.smb2 doesn't offer to use SMB2 in it's SMB Negotiation Request.
> (Payload is the same as that of mount.cifs .)
> 
> From Windows Vista client, SMB2 works well, so server setting is valid.
> 
> 
> Are there any mandatory settings (such as environment variables)
>  to run mount.smb2 as SMB2 client?
> 
> 
> 
> "cifs" is displayed in File system type field of mount output.
> ===================================================================
>  # mount.smb2 //server/share /mnt/smb2/ -o user=xxxx,pass=yyyy
>  # mount
>  ...
>  //server/share on /mnt/smb2 type cifs (rw,mand)
> ===================================================================
> 

I'm assuming you are using the recent cifs-utils package which supports
smb2.

>From where did you get mount.smb2? Is it a symlink to mount.cifs by any
chance?

Could you try

mount -t smb2 //server/share /mnt/point -o user=user1



--
Suresh Jayaraman
