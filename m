From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs client not forgiving enough when neg prot smb1 (with
 extended security)
Date: Thu, 28 May 2015 17:18:17 -0500
Message-ID: <CAH2r5mtxCfuRYvDyC33SZ-9yZY6U3Wd03+MLJEpAKrwZF3CiFw@mail.gmail.com>
References: <5565B33F.2020302@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: noel.power-IBi9RG/b67k@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5565B33F.2020302-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Wed, May 27, 2015 at 7:06 AM, Noel Power <nopower-IBi9RG/b67k@public.gmane.org> wrote:
> Hi Steve,
>
> Just came across a situation where cifs client was failing to mount a
> share with ntlmssp served by cifsd based server.
> The server is misbehaving in that is should have set the
> EncryptionKeyLength to zero (when offering extended security).
> Regardless though, a windows client will happily continue whereas the
> cifs client will return IO(5) error. Looking in the MS-SMB spec
> (2.2.4.5.2.1) mentions
>
> "ChallengeLength (1 byte): When the CAP_EXTENDED_SECURITY bit is set,
> the server MUST set this value to zero and clients MUST ignore this value."
>
> I attach a patch to cifs for this
>
> thanks,
>
> Noel



-- 
Thanks,

Steve
