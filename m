From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Fri, 14 Feb 2014 11:27:10 +0100
Message-ID: <52FDEF7E.9090401@assyoma.it>
References: <52F9EDA5.1020004@assyoma.it> <20140211103302.6d74b90d@tlielax.poochiereds.net> <52FA46D5.8020904@assyoma.it> <20140211124536.5fdcb56f@tlielax.poochiereds.net> <CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com> <20140213063738.1b345466@tlielax.poochiereds.net> <52FD0109.5030909@assyoma.it> <CAH2r5msMZsnC8hxh6=P=f_vsuB=DR_Hv9xyLUEZtG+WpzYU=Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	James McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msMZsnC8hxh6=P=f_vsuB=DR_Hv9xyLUEZtG+WpzYU=Sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On 02/13/2014 07:04 PM, Steve French wrote:
> I have not found fscache to be a problem in my tests, but did find
> problems with Samba 4.1 reexporting cifs directories.
>
> I am investigating this so any log information that you have or
> additional problem determination details would be appreciated.
>

Hi,
I have some difficulties in replicating the kernel panic; it happened 
one single time only. I will surely harvest in the log, but do you have 
any suggestions on what to search?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8
