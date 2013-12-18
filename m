From: Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Subject: Re: Mounting error after upgrading to wheezy - Changes in mount.cifs
 from 4.5 to 5.5?
Date: Wed, 18 Dec 2013 18:39:03 +0100
Message-ID: <52B1DDB7.3070909@phflesch.de>
References: <8f517d28f1398f0410e66e30d0aadd5a@localhost> <20131218114326.7f719964@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131218114326.7f719964-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,
> More likely, a change to the kernel and not cifs-utils is causing this
> for you. What kernels do your working and non-working configs have?
(working) squeeze --> 2.6.32-5-686-bigmem
(non-working) wheezy --> 3.2.0-4-686-pae

> Does it work if you mount with sec=ntlm ?
>
sec causes same error ...


Greetings

Philipp
