From: Pierre Frenkiel <pierre.frenkiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re:[Solved] permission denied on cifs mount
Date: Sun, 15 Dec 2013 19:22:27 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1312151830090.10698@pfr2.frenkiel-hure.net>
References: <alpine.DEB.2.10.1312151029090.26597@pfr2.frenkiel-hure.net> <1387122310.1886.11.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387122310.1886.11.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 15 Dec 2013, steve wrote:

> The answer is in /var/log/syslog just before the error message.

   hi Steve,
   sorry, but the syslog content is as useful as the mount error message -:)

   kernel: [695979.217883] CIFS VFS: Send error in SessSetup = -13
   kernel: [695979.218014] CIFS VFS: cifs_mount failed w/return code = -13

   Fortunately, I found the answer by looking for all the options
   in the mount.cifs man.  The one which worked was "sec=none", i.e.

      mount -t cifs -o sec=none //wehd/hdd /d6

   I tried the other possible values for sec, and found that

      mount -t cifs -o "guest,sec=ntlm" //wehd/hdd /d6
      mount -t cifs -o "guest,sec=ntlmv2" //wehd/hdd /d6

   also work.

   At last, I discovered that the difference from my 2 other machines
   comes from the kernel versions. My curent kernel version is 3.10-3,
   but if I boot the same machine selecting kernel 3.2, the command

      mount -t cifs -o guest //wehd/hdd /d6

   works.

   That obviously means that they changed the default
   security mode for cifs in the new kernel, although I found nothing
   about that in the kernel changelog.

best regards,
-- 
Pierre Frenkiel
