From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Tue, 27 Sep 2011 18:18:08 -0500
Message-ID: <CAH2r5msd+yLCxr8y6mTM83pyZ8Bc_GQf_LzyH_L9NPYgP=7YdA@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<20110927230155.GF23739@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110927230155.GF23739@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 27, 2011 at 6:01 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Have you notified the Microsoft engineers about this ? I can
> give you the right names to bug...

Yes.

It is trickier than I expected to reproduce (since we send large
writes, not all network interfaces are fast enough to support 127K
write size * 10 requests).


-- 
Thanks,

Steve
