From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add mount option to handle stat() failures by
 32-bit apps
Date: Tue, 11 Jan 2011 07:48:25 -0600
Message-ID: <AANLkTikgdweoohCJDVWRVQdJGL1nVPeJMGJgOmZHFAgh@mail.gmail.com>
References: <4D2C33A5.9000801@suse.de>
	<20110111105337.GA23753@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110111105337.GA23753-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 11, 2011 at 4:53 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> On Tue, Jan 11, 2011 at 04:10:37PM +0530, Suresh Jayaraman wrote:
>> ..compiled without LFS support, but running on 64-bit kernel.
>>
>> Currently, when a broken (compiled without LFS support) 32-bit appli=
cation on
>> a 64-bit kernel tries to do a stat(), it fails with -EOVERFLOW error=
=2E This
>> problem happens because the 32-bit application is unable to fit the =
huge
>> 64-bit inode number in its target structure field.
>
> This is nothing cifs specific. =A0Please do it in a generic way (e.g.
> sysctl) in the VFS.

Makes sense.  generic sysctl probably fine.



--=20
Thanks,

Steve
