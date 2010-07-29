From: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 29 Jul 2010 17:52:35 +0400
Message-ID: <54DA210795E649C1A62B5E10BF366BB3@lan.jax.org.ru>
References: <CC75E34383A8445493DD41AF4F7E7857@lan.jax.org.ru><20100721100503.672a735e@tlielax.poochiereds.net><9DFCDE0105DF4B70AEA82A8A2B2A2A94@lan.jax.org.ru> <20100722093121.4c64b102@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,
I've created a mirror cifs-utils repository where is embedded cifscreds 
utility. I've fixed a few bugs and added multilanguage support for it. Now 
it is locale-dependent, but then I plan to use the UCS-2 encoding. You can 
use the option --enable-cifscreds=yes of configure script to build 
cifscreds. I've also moved resolve_host routine in a separate file and made 
appropriate patches.

git://gitorious.org/cifs-utils/cifs-utils.git

Regards,
Igor Druzhinin
