From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Avoiding (DFS) regressions by having an automatic testing framework
Date: Thu, 10 May 2012 17:55:06 +0200
Message-ID: <4FABE4DA.3070408@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

As there were some DFS regressions that took a rather long time to get 
noticed, we want to avoid having these and other regressions reappear. 
So the idea is to set up a system that does some of the XFS testsuite 
tests for the linux cifs client and also does some 'remote' tests 
against Windows and Samba (including DFS).

Steve suggested to use resources Dann offered us lately. So I guess we 
have to look how we can coordinate and implement this all. Is someone 
volunteering to coordinate the efforts? I'm more than happy to help with 
integrating and maybe help writing some of the tests.

Cheers

Luk
