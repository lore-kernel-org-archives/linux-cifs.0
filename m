From: Pierre Frenkiel <pierre.frenkiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting error after upgrading to wheezy - Changes in mount.cifs
 from 4.5 to 5.5?
Date: Thu, 16 Jan 2014 09:39:00 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1401160937470.7734@pfr2.frenkiel-hure.net>
References: <8f517d28f1398f0410e66e30d0aadd5a@localhost> <20131218114326.7f719964@corrin.poochiereds.net> <52B1DDB7.3070909@phflesch.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B1DDB7.3070909-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Dec 2013, Philipp Flesch wrote:

> Hi Jeff,
>> More likely, a change to the kernel and not cifs-utils is causing this
>> for you. What kernels do your working and non-working configs have?
> (working) squeeze --> 2.6.32-5-686-bigmem
> (non-working) wheezy --> 3.2.0-4-686-pae
>
>> Does it work if you mount with sec=ntlm ?
>> 
> sec causes same error ...

   hi,
   I just see this mail now, coming back home...
   I had a similar problem when kernel change from 3.2 to 3.10.
   and found that the 3 following commands work:

      mount -t cifs -o sec=none //wehd/hdd /d6
      mount -t cifs -o "guest,sec=ntlm" //wehd/hdd /d6
      mount -t cifs -o "guest,sec=ntlmv2" //wehd/hdd /d6

best regards,
-- 
Pierre Frenkiel
