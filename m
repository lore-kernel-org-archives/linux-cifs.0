From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [Bug 197311] CIFS: mount.cifs stopped working with the Windows
 10 Pro 15063 SMB server
Date: Wed, 25 Oct 2017 16:14:32 -0500
Message-ID: <CAH2r5mtfoumpO4S5VhkqDJPvRDnKTPTyBAVk=4DvhYX5ycj7hw@mail.gmail.com>
References: <bug-197311-106681@https.bugzilla.kernel.org/> <bug-197311-106681-Z8cl32qM4P@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bug-197311-106681-Z8cl32qM4P-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix for problem with SMB3 validate_negotiate causing mount failure to
some versions of windows when mounting smb3 or later.

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=cf237481182846c508a4baa4f8281a2a7262ca09

---------- Forwarded message ----------
From:  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org>
Date: Thu, Oct 19, 2017 at 4:38 PM
Subject: [Bug 197311] CIFS: mount.cifs stopped working with the
Windows 10 Pro 15063 SMB server
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


https://bugzilla.kernel.org/show_bug.cgi?id=197311




-- 
Thanks,

Steve
