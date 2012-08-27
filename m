From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] CIFS mount =?UTF-8?B?aW50ZXJtaXR0ZeKAi250bHkgdW5hdmFp?=
 =?UTF-8?B?bGFibOKAi2U6?= cifs_mount failed w/return code = -5
Date: Mon, 27 Aug 2012 08:48:42 -0400
Message-ID: <20120827084842.5940e210@corrin.poochiereds.net>
References: <CACw2ZueN05TeAazv9yJgYcvbDgigQkvbtNUPaTGrfLzFVxiOZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert S <robert.spam.me.senseless-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACw2ZueN05TeAazv9yJgYcvbDgigQkvbtNUPaTGrfLzFVxiOZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Aug 2012 19:57:27 +1000
Robert S <robert.spam.me.senseless-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I have a debian machine called "debian" and a windows XP machine
> called "server".  I have a permanent mounted read-only share called
> \\server\doc.  My /etc/fstab looks like this:
> 
> //server/doc    /opt/chroot/mnt/server cifs
> credentials=/root/.smbmount,username=medical,uid=medical,file_mode=0755,dir_mode=0755,noserverino
> 0 0
> 
> This works well most of the time but at times I get a input/output
> error when I try to access this share.  My syslog shows the following:
> 
> Aug 16 15:36:35 debian kernel: [1289131.676869] Status code returned
> 0xc00000d0 NT_STATUS_REQUEST_NOT_ACCEPTED
> Aug 16 15:36:35 debian kernel: [1289131.676875]  CIFS VFS: Send error
> in SessSetup = -5
> Aug 16 15:36:35 debian kernel: [1289131.676899]  CIFS VFS: cifs_mount
> failed w/return code = -5
> Aug 16 15:36:46 debian kernel: [1289142.653770] Status code returned
> 0xc00000d0 NT_STATUS_REQUEST_NOT_ACCEPTED
> Aug 16 15:36:46 debian kernel: [1289142.653775]  CIFS VFS: Send error
> in SessSetup = -5
> Aug 16 15:36:46 debian kernel: [1289142.653799]  CIFS VFS: cifs_mount
> failed w/return code = -5
> Aug 16 15:37:01 debian kernel: [1289158.491697] Status code returned
> 0xc00000d0 NT_STATUS_REQUEST_NOT_ACCEPTED
> Aug 16 15:37:01 debian kernel: [1289158.491703]  CIFS VFS: Send error
> in SessSetup = -5
> Aug 16 15:37:01 debian kernel: [1289158.491727]  CIFS VFS: cifs_mount
> failed w/return code = -5
> 
> Does anyone have any suggestions?  Can somebody explain what return
> code -5 means?
> 
> I have tried replacing "server" with its fixed IP address
> (192.168.0.32), but this does not help.  I have even moved all the
> files to another location on the Windows box and recreated the share,
> but it still occurs.

(cc'ing linux-cifs ml)

-5 is -EIO which is the generic error that we map stuff to when there's
not a better mapping. We don't have a standard mapping for
NT_STATUS_REQUEST_NOT_ACCEPTED, so that's why you get -EIO back.

The bigger question is why your server is returning that error. You may
need to check the logs on the server side to see why it's not accepting
these requests.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
