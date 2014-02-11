From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Tue, 11 Feb 2014 19:09:47 +0100
Message-ID: <52FA676B.6070906@assyoma.it>
References: <52F9EDA5.1020004@assyoma.it>	<20140211103302.6d74b90d@tlielax.poochiereds.net>	<52FA46D5.8020904@assyoma.it> <20140211124536.5fdcb56f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211124536.5fdcb56f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> On Tue, 11 Feb 2014 16:50:45 +0100
> Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:
>
> The rationale is that windows servers always send a NumberOfLinks value
> of '0' for directories. We have a hack in place that went in around a
> year ago to work around that for (arguably broken) applications that
> try to infer something about an inode that has a zero st_nlink value.
>
> There is no workaround. Either fix the application such that it doesn't
> care or patch the kernel. I'll cc Jim since he did a fair bit of
> looking at this several months ago.
>
> In truth though, resharing a cifs mount is probably not a great
> solution. It sounds like the kind of setup that's going to end up being
> fraught with cache coherency problems...

Ok, I understand now :)

Thank you very much, Jeff.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8
