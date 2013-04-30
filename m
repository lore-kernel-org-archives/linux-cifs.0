From: Peter Parzer <peter.parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
Subject: Re: multiuser kerberised cifs via autofs needs root ticket cache
Date: Tue, 30 Apr 2013 16:07:20 +0200
Message-ID: <517FD018.40106@med.uni-heidelberg.de>
References: <51723F74.3010807@steve-ss.com> <20130426101410.1754c9ab@tlielax.poochiereds.net> <517B0C3A.80809@steve-ss.com> <20130430092212.53254831@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130430092212.53254831-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Am 30.04.2013 15:22, schrieb Jeff Layton:
>
> No, that's not what I'm saying at all. You can get the same effect by
> setting up credentials for root in /etc/krb5.keytab. Just pass in the
> correct username= mount option for the principal that you want root to
> be.
>

Not exactly on the topic, but I have been struggling a long time with 
this question. How can I setup credentials for root in /etc/krb5.keytab? 
I do the cifs multiuser mount in /etc/fstab at boot time. To create 
Kerberos tickets for root I have a network if-up hook with the command 
"net ads kerberos kinit -P". Is there an easier way using the keytab file?



Peter
