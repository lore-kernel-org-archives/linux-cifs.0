From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: long name length protection triggering when it shouldn't
Date: Thu, 26 Oct 2017 18:36:17 -0400 (EDT)
Message-ID: <355654398.20246337.1509057377124.JavaMail.zimbra@redhat.com>
References: <alpine.DEB.2.20.1710261653580.1395@Lib-ITS13.lib.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Hill <jackhill-4+jYJfmkT58@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1710261653580.1395-WLjXm773ss2rwpbwKtlw2QLqUvEzMhQG@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks for the report.

I had a report yesterday about the name length check failing together with DFS use,
this was fixed by applying this patch :

http://www.spinics.net/lists/linux-cifs/msg13458.html

Can you try that patch and confirm if it fixes the issue for you too ?


regards
ronnie sahlberg


----- Original Message -----
From: "Jack Hill" <jackhill-4+jYJfmkT58@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, 27 October, 2017 8:13:27 AM
Subject: long name length protection triggering when it shouldn't

Hi,

I believe that I'm having a problem where the checks in 
5ed70f7db9afe5e4e5cc1fa2239676e3b2d2c5b2 for file name length are 
triggering when they shouldn't be. I see this problem on a normal Debian 
Stretch system where the patch in question was introduced in Debian's 
linux-image-4.9.0-4-amd64 kernel. I believe that the errors about file 
name length are erroneous because I see no problems when using a prior 
kernel. As an added twist, I only see this problem when using the sec=krb5 
option. If I use sec=ntlmv2, the problem does not occur. I am looking for 
advice on how to troubleshoot further.

More information can be found in a post I made to a different list about 
this issue 
<https://trilug.org/pipermail/trilug/Week-of-Mon-20171023/077662.html>.

Thanks,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
