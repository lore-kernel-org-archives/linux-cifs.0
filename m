From: Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Mon, 06 Dec 2010 16:11:05 +0100
Message-ID: <20101206161105.20365wibtcv7jw8w@webmail.df.eu>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
 <20101206095725.78422138@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206095725.78422138-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

Zitat von Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>
> This doesn't look right to me...
>
> i_ino is an unsigned long. The code in filldir() is this:
>
>         unsigned long d_ino;

You need to look at compat_filldir():

         compat_ulong_t d_ino;


Regards,
Bernhard
