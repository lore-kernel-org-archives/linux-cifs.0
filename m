From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb3 mount fix for Macs
Date: Wed, 3 May 2017 21:25:50 -0500
Message-ID: <CAH2r5mtrghs-cnnxDvwtSzz5orUxNU-xpwFxJ0GVCr2BCeDOWg@mail.gmail.com>
References: <CAH2r5mtm7mJn7V5qiP6Xz3PW-+d_j02idQcsZkgfS3Gqw4=92g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtm7mJn7V5qiP6Xz3PW-+d_j02idQcsZkgfS3Gqw4=92g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor update and added cc:stable

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=7db0a6efdc3e990cdfd4b24820d010e9eb7890ad

On Wed, May 3, 2017 at 9:23 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> pushed patch to workaround smb3 mount failure to Mac
>
> (we had to relax our length checks on the response to smb2 ioctl for
> validate negotiate since they pad in order to return the maximum
> buffer allowed - 16K for what is normally a rather small ioctl
> response).
>
> smb3 mounts now work to Macs again (smb2.1 mounts to Mac had always
> been find - it only failed to smb3 due to the validate negotiate
> ioctl)
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=be60379eac1c023f9b77565060414e5b122de766
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
