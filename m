From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allow setting per-file compression via SMB3
Date: Tue, 8 Oct 2013 09:51:05 -0500
Message-ID: <CAH2r5mtUni4vWQTDS7SS0gU04FavFGR43HagRXwJPYdGszdnag@mail.gmail.com>
References: <CAH2r5muzG6m8UAc5_OEKT5FGtk-FJgtSH2FaVgQFvmvnR0znZg@mail.gmail.com>
	<5253B13A.3070403@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5253B13A.3070403-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 8, 2013 at 2:16 AM, Stefan (metze) Metzmacher
<metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Steve,
>
>> Allow cifs/smb2/smb3 to return whether or not a file is compressed
>> via lsattr, and allow SMB3 to set the per-file compression flag
>> ("chattr +c filename" on an smb3 mount).
>
> Why is this SMB3 specific?

Just to make testing easier.  I can add SMB2.1 easily enough
and test it against Windows 7 this morning, and SMB2.02 should be


>> Windows users often set the compressed flag (it can be
>> done from the desktop and file manager).  David Disseldorp
>> has patches to Samba server to support this (at least on btrfs)
>> which are complementary to this.
>>
>> Wish chattr supported the per-file encryption flag (that
>> presumably would be easy to set too via SMB3)
>
> It seems there're some unrelated changes in the commit,
> wouldn't it be better to split this into 2 or 3 commits?

There was one header cleanup for the sockaddr info in the network interface
request that I will remove from this and move to the query network
interfaces fsctl patch


-- 
Thanks,

Steve
