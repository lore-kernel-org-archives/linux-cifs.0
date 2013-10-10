From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [[PATCH v2] [CIFS] Allow setting per-file compression via SMB2
 and SMB3
Date: Thu, 10 Oct 2013 08:50:53 -0500
Message-ID: <CAH2r5muv6Rz6yphii6c9EquBTm10zdag20J1tua0sK8y47tMFw@mail.gmail.com>
References: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
	<52564845.9040205@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52564845.9040205-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 10, 2013 at 1:25 AM, Stefan (metze) Metzmacher
<metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Steve,
>
>> Allow cifs/smb2/smb3 to return whether or not a file is compressed
>> via lsattr, and allow SMB2/SMB3 to set the per-file compression
>> flag ("chattr +c filename" on an smb2 or smb3 mount).
>
> There're still unrelated generic fixes in SMB2_ioctl(), which would
> a separate commit.

Not totally unrelated because I noticed I had to fix the length
calculation when trying to get this particular ioctl to work, but it
is easy enough to break into another patch. Will do.

> I also don't understand why the set operation should not be available
> in all protocols, there's nothing SMB2 or SMB3 specific.

I could add the cifs ioctl as a followon patch but figured cifs was
lower priority because vast majority of current servers would have at
least smb2.   Was trying to focus on the remaining missing ioctls and
fs info calls that SMB2/SMB3 should be able to make (e.g. verify
negotiate, copy offload, query adapter info etc.)



-- 
Thanks,

Steve
