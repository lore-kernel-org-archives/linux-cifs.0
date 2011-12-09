From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 8 Dec 2011 22:08:18 -0600
Message-ID: <CAH2r5muZhQqKH9x8F2rWOD_gtrSQOETMQFBpaWP9hEJ5Fx3=WA@mail.gmail.com>
References: <CAH2r5mtW3k8DqsJsJzuYG=VTYD8u2vqKSmbhBvNG6H_E2i_TAg@mail.gmail.com>
	<CA+55aFy5C8i4vpP2+6k0B1Y0EoDtNzfJvr4YyGOwjewT3GLfyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy5C8i4vpP2+6k0B1Y0EoDtNzfJvr4YyGOwjewT3GLfyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You are correct.  I forgot to rebase before I checked. I rebased, and
will resend the merge request.

On Thu, Dec 8, 2011 at 3:20 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Dec 8, 2011 at 11:36 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>>
>> Jeff Layton (2):
>> =A0 =A0 =A0cifs: attempt to freeze while looping on a receive attemp=
t
>> =A0 =A0 =A0cifs: check for NULL last_entry before calling cifs_save_=
resume_key
>>
>> =A0fs/cifs/connect.c | =A0 =A02 ++
>> =A0fs/cifs/readdir.c | =A0 10 ++++++++--
>> =A02 files changed, 10 insertions(+), 2 deletions(-)
>
> This is not at all what I get. I get those two, but I also get
>
> =A0Pavel Shilovsky (1):
> =A0 =A0 =A0CIFS: Add descriptions to the brlock cache functions
>
> =A0Steve French (1):
> =A0 =A0 =A0cifs: Fix sparse warning when calling cifs_strtoUCS
>
> Not pulled, I don't pull from branches that don't match the descripti=
on.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Linus



--=20
Thanks,

Steve
