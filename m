From: Jack Hill <jackhill-4+jYJfmkT58@public.gmane.org>
Subject: Re: long name length protection triggering when it shouldn't
Date: Fri, 27 Oct 2017 20:58:15 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1710272053520.3868@Lib-ITS13.lib.duke.edu>
References: <alpine.DEB.2.20.1710261653580.1395@Lib-ITS13.lib.duke.edu> <355654398.20246337.1509057377124.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <355654398.20246337.1509057377124.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 Oct 2017, Leif Sahlberg wrote:

> Can you try that patch and confirm if it fixes the issue for you too ?

I am happy to confirm that the patch fixes the issue for me.

Is it worth trying to figure out why MaxPathNameComponentLength is not 
being set correctly? For me, it seems to be set correctly when I use 
different mount options (either a different sec= option, or when using 
multiuser).

Do you expect the proposed patch to be the eventual fix that ends up in a 
released kernel?

Thanks,
Jack
