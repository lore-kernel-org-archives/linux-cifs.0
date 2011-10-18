From: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: Re: mount.cifs on Win2k8 DFS servers
Date: Tue, 18 Oct 2011 11:18:20 +0200
Message-ID: <4E9D445C.1020805@keymile.com>
References: <4E9C1876.5090205@keymile.com><20111017123635.GA5978@cobija.connexer.com><4E9C43F6.9050702@keymile.com> <20111017171152.GA7102@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017171152.GA7102-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/17/2011 07:11 PM, sean finney wrote:
> I don't think smbclient's behavior is correct either though.  It's
> a ways back now, but at the time I compared the existing behavior of
> smbclient, a couple different windows clients, and cifs.ko, and none
> were really consistant with the other.

I didn't dive deep enough into this, but my XP client didn't even try 
connecting, it would just go straight to getting a DFS referral, and 
that seemed consistent with smbclient. How it made that decision, 
though, I really don't know.

 > The reference doc was not entirely specific either IIRC.

I would be surprised if it were consistent, let alone specific... :-)

> But based on what the module was already doing, it seemed "right enough"
> anyway, and with cleanup/refactoring was kept pretty clean in case
> someone wants to improve on it in the future :)

I see. Won't ask any more questions. Thanks for fixing it! :-)

>> 2) Shouldn't this/these patch/es also make it into earlier kernels
>> as it is a (not-so-negligible) bugfix?
>
> I don't think it's super trivial to backport it before 2.6.38, at least
> without massaging the patches and cherry picking a few more commits that
> cross paths and/or touch the relevant api's.  But there've been enough
> other bugfixes in the cifs code that for our needs we just upgraded to
> a backported 2.6.38 kernel and dumped the pre-3.0 cifs commit history
> on top of it (we didn't go all the way to 3.0 for entirely uninteresting
> reasons, you should just do that if you have the ability).

It merged easily into my 2.6.39.3, and that'll do for now. :-)

Gerlando
