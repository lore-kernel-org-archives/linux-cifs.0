From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 8 Jul 2010 14:04:31 -0400
Message-ID: <20100708140431.612feefe@corrin.poochiereds.net>
References: <469B064927F7461992FFB15852A3B90F@lan.jax.org.ru>
	<20100708125915.5e4eb643@corrin.poochiereds.net>
	<7E471FB7A6424D8595FEB4122BC8E0BA@lan.jax.org.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E471FB7A6424D8595FEB4122BC8E0BA-PUkIMHyhFB22ZuJnPpCLiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 8 Jul 2010 21:28:34 +0400
"Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> As I have seen the domain name from domain= option parameter directly copied 
> to SMB Session Setup packet in Primary Domain field that tells to server in 
> what domain it is necessary to search for the information on an account. I 
> think that short domain name that was entered in domain= field - for example 
> LAN can be interpreted on one host as LAN.XXX.COM and LAN.YYY.COM on 
> another.

Yes, it does get copied in. I'm just not sure that the server really
cares about it at all. The entire domain= parameter could use a
thorough review, in other words...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
