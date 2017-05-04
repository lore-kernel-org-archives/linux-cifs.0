From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: smb3 mount fix for Macs
Date: Thu, 4 May 2017 12:24:47 +0200
Message-ID: <20170504122447.03f54767@suse.de>
References: <CAH2r5mtm7mJn7V5qiP6Xz3PW-+d_j02idQcsZkgfS3Gqw4=92g@mail.gmail.com>
        <CAH2r5mtrghs-cnnxDvwtSzz5orUxNU-xpwFxJ0GVCr2BCeDOWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtrghs-cnnxDvwtSzz5orUxNU-xpwFxJ0GVCr2BCeDOWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 3 May 2017 21:25:50 -0500, Steve French wrote:

> Minor update and added cc:stable
> 
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=7db0a6efdc3e990cdfd4b24820d010e9eb7890ad

The relaxed validate negotiate rsplen check looks okay, but I think the
reduced MaxOutputResponse change should probably be split out into a
separate commit, as it affects all other ioctls.

Given that the response size is known in advance, couldn't we have the
validate_negotiate caller pass in the desired MaxOutputResponse value?

Cheers, David
