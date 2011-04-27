From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Wed, 27 Apr 2011 09:59:52 -0500
Message-ID: <BANLkTiko7K1HJFjAKfRokmFiWk=+rHe0DA@mail.gmail.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<20110427101740.32be5c28@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427101740.32be5c28-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I will try to get the remaining cleanup patches (such as the bcc
little endian patches) remerged over the next few days - that should
make this easier to respin

On Wed, Apr 27, 2011 at 9:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 26 Apr 2011 08:03:16 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> This patchset fixes a number of problems that David pointed out whil=
e
>> reviewing some backports for RHEL. I think they're appropriate for
>> 2.6.39 and probably the stable series as well.
>>
>> Jeff Layton (5):
>> =A0 cifs: change bleft in decode_unicode_ssetup back to signed type
>> =A0 cifs: check for bytes_remaining going to zero in CIFS_SessSetup
>> =A0 cifs: sanitize length checking in coalesce_t2
>> =A0 cifs: refactor mid finding loop in cifs_demultiplex_thread
>> =A0 cifs: handle errors from coalesce_t2
>>
>> =A0fs/cifs/connect.c | =A0117 +++++++++++++++++++++++++++++---------=
--------------
>> =A0fs/cifs/sess.c =A0 =A0| =A0 19 ++-------
>> =A02 files changed, 69 insertions(+), 67 deletions(-)
>>
>
> Note too that some of this patchset has merge conflicts with the patc=
h
> to change the BCC to little-endian. I'll plan to respin that patch on=
ce
> you let me know what you plan to do with this set.
>
> Thanks,
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Thanks,

Steve
