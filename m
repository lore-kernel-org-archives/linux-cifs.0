From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb3 mount fix for Macs
Date: Thu, 4 May 2017 11:43:39 -0700
Message-ID: <CAKywueR3XgeCHRu_a6CJ9gk33CveMjSLivkRXAjuwOZP4O4FSw@mail.gmail.com>
References: <CAH2r5mtm7mJn7V5qiP6Xz3PW-+d_j02idQcsZkgfS3Gqw4=92g@mail.gmail.com>
 <CAH2r5mtrghs-cnnxDvwtSzz5orUxNU-xpwFxJ0GVCr2BCeDOWg@mail.gmail.com>
 <20170504122447.03f54767@suse.de> <CAH2r5mvt2MKaeMC7zJ+xX5jXpEMGWP6ja4F-BmwPq8q=TdNGOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvt2MKaeMC7zJ+xX5jXpEMGWP6ja4F-BmwPq8q=TdNGOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-05-04 3:30 GMT-07:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, May 4, 2017 at 5:24 AM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
>> On Wed, 3 May 2017 21:25:50 -0500, Steve French wrote:
>>
>>> Minor update and added cc:stable
>>>
>>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=7db0a6efdc3e990cdfd4b24820d010e9eb7890ad
>>
>> The relaxed validate negotiate rsplen check looks okay, but I think the
>> reduced MaxOutputResponse change should probably be split out into a
>> separate commit, as it affects all other ioctls.
>
> That is a good thing in a way - because we don't want any ioctls to
> send more than maxbufsize until we can handle this.
>

I agree that we need to split the patch into two because it is
targeted to stable. SMB2_ioctl() and smb3_validate_negotiate() were
introduced in different times, so the single patch won't be applied
properly on some stable kernel versions.

--
Best regards,
Pavel Shilovsky
