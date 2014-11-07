From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: user mount.cifs with credentials file results in "error 13
 (Permission denied) opening credential file"
Date: Fri, 7 Nov 2014 10:45:48 -0500
Message-ID: <20141107104548.627864b8@tlielax.poochiereds.net>
References: <545AE5D5.7090602@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael_OF <michaelof-ur4TIblo6goN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545AE5D5.7090602-ur4TIblo6goN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 06 Nov 2014 04:07:01 +0100
Michael_OF <michaelof-ur4TIblo6goN+BqQ9rBEUg@public.gmane.org> wrote:

> Hi all,
> 
> 
> I want to enable a user mount of a remote samba share. OpenSuse 13.1.
> First step was to enable setuid bit for /etc/mount.cifs.
> To keep mount as easy as possible, I've added an /etc/fstab entry like this:
>    //host/share /mount_dir user=user,users 0 0
> 
> Works fine in bash, prompts for remote user's password.
> Does not work in KDE's dolphin, no action when clicking on location bar's entry "share on host"
> 
> I then recognized the "credentials" option and changed the /etc/fstab entry like this:
>    //host/share /mount_dir cifs credentials=/root/cred-file,users 0 0
> 
> (sudo chmod 600 /root/cred-file, to protect password)
> 
> Having done this, e.g.
>    mount /mount_dir
> as "root" or with sudo works fine.
> 
> But NOT as an end user: "error 13 (Permission denied) opening credential file /root/cred-file"
> Both in bash or Dolphin.
> 
> chmod to allow read credential file for any user "solves" the problem, so it's really a local access right issue.
> 
> Which in fact seems to make user cifs mount impossible, at least this way.
> And which confuses me: Why, if the mount.cifs program has the sticky bit set, it's not allowed to open a root-owned file?
> 
> Is this a bug, should I file it in bugzilla?
> 
> 
> Thanks in advance,
> Michael
> 

No, it's expected behavior...

mount.cifs uses privilege separation. The parent is privileged and
handles the actual mount. The child is forked from the parent, drops
privileges/changes to the real uid, etc. That process is what parses
and handles mount options, which includes parsing the credentials file.
In your case, the cred file isn't readable by the unprivileged user.

The upshot here is that if you want to mount using a credentials file
as an unprivileged user, then your unprivileged user must also have
read access to read that file. Doing anything else would be tantamount
to giving unprivileged users the ability to access files they wouldn't
otherwise be able to access.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
