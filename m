From: Ben Harris <bjh21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: TLINK_ERROR_EXPIRE breakage
Date: Thu, 1 Sep 2016 17:26:29 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1609011625050.20241@thunderbird-1.linux.ds.cam.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: UIS Platforms <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have a system that uses CIFS for users' home directories, and that uses 
pam_cifscreds to inject the user's password into the kernel keyring at 
login.  Using the stock Ubuntu 16.04 kernel (4.4.0-36-generic) we get 
problems on console and SSH logins where Bash can't read .bash_profile:

Last login: Thu Sep  1 16:34:17 2016 from 172.24.193.54
-bash: /home/bjh21/.bash_profile: Permission denied

But if I then type "ls", everything seems to be fine.

I think the problem here is that parts of the login process try to access 
the user's home directory early (e.g. login(8) tries to read 
~/.hushlogin).  At that point, the user's password isn't in the kernel 
keyring yet, so request_key() fails.  Then, when an attempt is made to 
access the user's home directory after the password has been injected, 
this case in cifs_sb_tlink() fires:

                 /* return error if we tried this already recently */
                 if (time_before(jiffies, tlink->tl_time + TLINK_ERROR_EXPIRE)) {
                         cifs_put_tlink(tlink);
                         return ERR_PTR(-EACCES);
                 }

Essentially, the CIFS layer is caching the failed key look-up for a 
second even though in the intervening time the kernel has received a 
suitable key.

I can demonstrate that the problem is a 1-second timeout by, for instance, 
"ssh warg 'sleep 0.9; ls'", where the "ls" fails, but the same command 
with a 1.1-second sleep succeeds.  More amusingly, a sequence of ls'es 
interspersed with "sleep 0.9" can keep the negative cache entry alive 
indefinitely.

To work around this problem, I've build a CIFS module that defines 
TLINK_ERROR_EXPIRE to -1, which effectively disables the above check. 
This seems to have solved our problems.  Maybe there are cases where this 
negative caching is necessary, though, so a more subtle approach might be 
required.

-- 
Ben Harris, University of Cambridge Information Services.
