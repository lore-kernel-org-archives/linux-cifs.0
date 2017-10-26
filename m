From: Jack Hill <jackhill-4+jYJfmkT58@public.gmane.org>
Subject: long name length protection triggering when it shouldn't
Date: Thu, 26 Oct 2017 17:13:27 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1710261653580.1395@Lib-ITS13.lib.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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
