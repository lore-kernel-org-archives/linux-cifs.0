From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb3 mount fix for Macs
Date: Thu, 4 May 2017 05:30:47 -0500
Message-ID: <CAH2r5mvt2MKaeMC7zJ+xX5jXpEMGWP6ja4F-BmwPq8q=TdNGOg@mail.gmail.com>
References: <CAH2r5mtm7mJn7V5qiP6Xz3PW-+d_j02idQcsZkgfS3Gqw4=92g@mail.gmail.com>
 <CAH2r5mtrghs-cnnxDvwtSzz5orUxNU-xpwFxJ0GVCr2BCeDOWg@mail.gmail.com> <20170504122447.03f54767@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504122447.03f54767-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 4, 2017 at 5:24 AM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> On Wed, 3 May 2017 21:25:50 -0500, Steve French wrote:
>
>> Minor update and added cc:stable
>>
>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=7db0a6efdc3e990cdfd4b24820d010e9eb7890ad
>
> The relaxed validate negotiate rsplen check looks okay, but I think the
> reduced MaxOutputResponse change should probably be split out into a
> separate commit, as it affects all other ioctls.

That is a good thing in a way - because we don't want any ioctls to
send more than maxbufsize until we can handle this.

> Given that the response size is known in advance, couldn't we have the
> validate_negotiate caller pass in the desired MaxOutputResponse value?

Perhaps - but I don't know if that makes sense until we have way of
handling more than max buf size (defaults to 16K payload) in smb2
ioctl/fsctl response.

My gut reaction is to change the code to allow passing in maxoutput
for response on ioctl when we have a way of handling 'very large'
ioctl responses in demultiplexing in smb2 transport layer.


-- 
Thanks,

Steve
