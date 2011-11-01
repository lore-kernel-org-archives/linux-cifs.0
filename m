From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Tue, 1 Nov 2011 06:04:28 -0400
Message-ID: <20111101060428.5d474bb9@tlielax.poochiereds.net>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Nov 2011 00:12:21 +0100
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> I would like to test the multiusermounts?
> 
> I know to set:
> 
>  echo 1 > /proc/fs/cifs/MultiuserMount
> 
> and add an option to the mount command, but I can remember/read somewhere
> that one have to add some mapping somehwere:
> 
> local user : remote user
> ...
> 
> Is this correct?
> 

No. The MultiuserMount code that the above switch activates is
basically deprecated (and never worked very well in the first place).
The correct way to do this is to use sec=krb5 and mount with '-o
multiuser'. Then, make sure all users accessing the mount have a TGT.

If you're using unix extensions (generally meaning that the remote
server is samba-based), then having unity-mapped uids is helpful.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
