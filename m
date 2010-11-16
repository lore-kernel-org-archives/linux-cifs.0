From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 12:47:07 -0600
Message-ID: <AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289893710-7352-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 16, 2010 at 1:48 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If we have a share mounted by non-standard port and try to mount another share
> on the same host with standard port, we connect to the first share again -
> that's wrong. This patch fixes this bug.

The description seems a little strange - can you clarify?

If we have an existing session with a server (using whatever port), by
default we want to use it (unless the user forces a different port
than the existing connection was made with).  If we have a firewall
issue and therefore go through a non-standard port (port=something on
mount), we usually wouldn't want to fork a new connection on a second
connection to the same server.

So if we specify port=5000 on a mount and we already have a mount on
port 139, it makes sense that we would want to create a new session.
But if you already have a mount on port 5000, and did a mount with no
port specified - why wouldn't you use the existing port?  It saves
server, client and network resources.

-- 
Thanks,

Steve
