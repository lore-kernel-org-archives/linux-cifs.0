From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: TLINK_ERROR_EXPIRE breakage
Date: Fri, 02 Sep 2016 09:28:01 -0400
Message-ID: <1472822881.23692.9.camel@poochiereds.net>
References: <alpine.DEB.2.10.1609011625050.20241@thunderbird-1.linux.ds.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: UIS Platforms <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Ben Harris <bjh21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1609011625050.20241-DQa+Qhn4Z596hOdV6ebWgAmrLCtcsW2JsGvUnSjEs/k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-09-01 at 17:26 +0100, Ben Harris wrote:
> We have a system that uses CIFS for users' home directories, and that uses 
> pam_cifscreds to inject the user's password into the kernel keyring at 
> login.  Using the stock Ubuntu 16.04 kernel (4.4.0-36-generic) we get 
> problems on console and SSH logins where Bash can't read .bash_profile:
> 
> Last login: Thu Sep  1 16:34:17 2016 from 172.24.193.54
> -bash: /home/bjh21/.bash_profile: Permission denied
> 
> But if I then type "ls", everything seems to be fine.
> 
> I think the problem here is that parts of the login process try to access 
> the user's home directory early (e.g. login(8) tries to read 
> ~/.hushlogin).  At that point, the user's password isn't in the kernel 
> keyring yet, so request_key() fails.  Then, when an attempt is made to 
> access the user's home directory after the password has been injected, 
> this case in cifs_sb_tlink() fires:
> 
>                  /* return error if we tried this already recently */
>                  if (time_before(jiffies, tlink->tl_time + TLINK_ERROR_EXPIRE)) {
>                          cifs_put_tlink(tlink);
>                          return ERR_PTR(-EACCES);
>                  }
> 
> Essentially, the CIFS layer is caching the failed key look-up for a 
> second even though in the intervening time the kernel has received a 
> suitable key.
> 
> I can demonstrate that the problem is a 1-second timeout by, for instance, 
> "ssh warg 'sleep 0.9; ls'", where the "ls" fails, but the same command 
> with a 1.1-second sleep succeeds.  More amusingly, a sequence of ls'es 
> interspersed with "sleep 0.9" can keep the negative cache entry alive 
> indefinitely.
> 
> To work around this problem, I've build a CIFS module that defines 
> TLINK_ERROR_EXPIRE to -1, which effectively disables the above check. 
> This seems to have solved our problems.  Maybe there are cases where this 
> negative caching is necessary, though, so a more subtle approach might be 
> required.
> 

Interesting. It has been a while since that code was written, but IIRC
the main worry was spamming the server (and upcalls) that are just
going to fail.

A more subtle approach may make sense there though. One idea might be
to continue to retry for a period of time, and only back off with
EACCES errors after that. Or, we could just sleep in the kernel for a
bit, and retry there, and only give up after that fails for a while.

I guess it comes down to: "What behavior makes the most sense in the
most situations?"

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
