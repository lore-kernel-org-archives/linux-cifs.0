From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Wed, 2 May 2012 11:59:57 -0500
Message-ID: <CAH2r5mts3KEpv-dBTQOF0oVCru5ZHor-rtj8KUi=_ARPmHZ8KQ@mail.gmail.com>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
	<CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com>
	<CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
	<4FA11E59.9050004@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA11E59.9050004-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Wed, May 2, 2012 at 6:45 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> =
wrote:
> On 04/28/2012 09:03 AM, Steve French wrote:
>> The fix makes sense, but it is fairly recent and I haven't had a
>> chance to try it,
>> so unless a new release is imminent, I would prefer to put in the ne=
xt merge
>> request (I have at least one more fix likely as well) next week.
>
> We need this fix for -stable as well, right? Please include
>
> =A0 Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>
> Suresh
>
>



--=20
Thanks,

Steve
