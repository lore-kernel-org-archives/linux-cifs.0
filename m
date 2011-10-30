From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/53] CIFS: Allow SMB2 statistics to be tracked
Date: Sat, 29 Oct 2011 21:52:03 -0500
Message-ID: <CAH2r5mt9XmYoZUtjZ5f4FQw0nAT1X2i2fy=FhWqmHH72mfvnnA@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-3-git-send-email-piastry@etersoft.ru>
	<20111029004814.41340503@corrin.poochiereds.net>
	<CAKywueQwBwR-HZtv6gQv32kt4+2qycS7vq5KDLiE3xw3_9=wPA@mail.gmail.com>
	<20111029221251.5fba1444@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029221251.5fba1444-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 29, 2011 at 9:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 29 Oct 2011 23:44:53 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/10/29 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> ...
>> >> + =A0 =A0 union {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_writes;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_reads;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_flushes;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_oplock_brk=
s;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_opens;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_closes;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_deletes;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_mkdirs;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixopens=
;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixmkdir=
s;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_rmdirs;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_renames;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_t2renames;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_ffirst;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fnext;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fclose;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_hardlinks;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_symlinks;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_locks;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_get;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_set;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 } cifs_stats;
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_sent[=
NUMBER_OF_SMB2_COMMANDS];
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_fail[=
NUMBER_OF_SMB2_COMMANDS];
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 } smb2_stats;
>> >
>> > Is it really necessary to do this with atomics? Those can have
>> > significant performance impact (TLB flushes, and we don't seem to =
need the
>> > guarantees that they provide for simple counters like this. Perhap=
s
>> > these should be switched to per-cpu variables or just plain ints?
>>
>> I am not sure I understand your idea to make it as int. What's about
>> concurrency?
>>
>
> Sorry, I was reviewing these while on little sleep. We do need to wor=
ry
> about concurrency here so ints are probably not appropriate (unless
> these are already being incremented under a lock of some sort). Percp=
u
> variables though would be ideal for this.

Using per-cpu variables sounds reasonable, but that seems like somethin=
g
that is lower priority (than much of your other patch feedback) for Pav=
el
to change in the short term since the current approach works
(albeit slightly slower when STATS2 is enabled).

--=20
Thanks,

Steve
