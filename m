From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 02/53] CIFS: Allow SMB2 statistics to be tracked
Date: Sat, 29 Oct 2011 01:32:05 -0400
Message-ID: <20111029013205.33647544@corrin.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-3-git-send-email-piastry@etersoft.ru>
	<20111029004814.41340503@corrin.poochiereds.net>
	<CAH2r5mtpckA75LEAynsPLVsPfr7U0wnYAyZ1uKeK2VU9F1CGeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtpckA75LEAynsPLVsPfr7U0wnYAyZ1uKeK2VU9F1CGeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Oct 2011 00:12:45 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Oct 28, 2011 at 11:48 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Fri, 28 Oct 2011 23:54:13 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >>
> >> Adding SMB2 statistics requires changes to the way cifs handles st=
ats.
> >> Since there are only 19 command codes, it also is easier to track =
by exact
> >> command code than it was for cifs. =C2=A0Turn the counters for pro=
tocol
> >> ops sent to be a union (one struct for cifs, one for smb2). =C2=A0=
While at it
> >> split out the functions which clear stats and prints stats into th=
eir own
> >> subfunctions so they are easy to read and don't go past 80 columns=
=2E
> >>
> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifs_debug.c | =C2=A0146 +++++++++++++++++++++++++++=
+++-------------------
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 | =C2=A0 56 ++++++++++++-------
> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0| =C2=A0 54 +++++++++--------=
-
> >> =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> >> =C2=A04 files changed, 152 insertions(+), 106 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> >> index 84e8c07..8ccdb15 100644
> >> --- a/fs/cifs/cifs_debug.c
> >> +++ b/fs/cifs/cifs_debug.c
> >> @@ -249,6 +249,55 @@ static const struct file_operations cifs_debu=
g_data_proc_fops =3D {
> >> =C2=A0};
> >>
> >> =C2=A0#ifdef CONFIG_CIFS_STATS
> >> +
> >> +#ifdef CONFIG_CIFS_SMB2
> >> +static void smb2_clear_stats(struct cifs_tcon *tcon)
> >> +{
> >> + =C2=A0 =C2=A0 int i;
> >> +
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->num_smbs_sent, 0);
> >> + =C2=A0 =C2=A0 for (i =3D 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(&tcon->stat=
s.smb2_stats.smb2_com_sent[i], 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(&tcon->stat=
s.smb2_stats.smb2_com_fail[i], 0);
> >> + =C2=A0 =C2=A0 }
> >> +}
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> +
> >> +static void clear_cifs_stats(struct cifs_tcon *tcon)
> >> +{
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->num_smbs_sent, 0);
> >> +
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 if (tcon->ses->server->is_smb2) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smb2_clear_stats(tcon)=
;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> >> + =C2=A0 =C2=A0 }
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> +
> >
> > =C2=A0 =C2=A0 ^^^^^^^^^^^^^
> > The above logic should be encapsulated in smb2_clear_stats, and tha=
t
> > function should just be a noop when CONFIG_CIFS_SMB2 is not set.
>=20
> makes sense - could be easier to read your way
>=20
>=20
> >> + =C2=A0 =C2=A0 /* cifs specific statistics, not applicable to smb=
2 sessions */
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_writes, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_reads, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_flushes, 0)=
;
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_oplock_brks=
, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_opens, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_posixopens,=
 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_posixmkdirs=
, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_closes, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_deletes, 0)=
;
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_mkdirs, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_rmdirs, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_renames, 0)=
;
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_t2renames, =
0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_ffirst, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_fnext, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_fclose, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_hardlinks, =
0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_symlinks, 0=
);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_locks, 0);
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_acl_get, 0)=
;
> >> + =C2=A0 =C2=A0 atomic_set(&tcon->stats.cifs_stats.num_acl_set, 0)=
;
> >> +}
> >> +
> >> =C2=A0static ssize_t cifs_stats_proc_write(struct file *file,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const char __user=
 *buffer, size_t count, loff_t *ppos)
> >> =C2=A0{
> >> @@ -279,25 +328,7 @@ static ssize_t cifs_stats_proc_write(struct f=
ile *file,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcon=
 =3D list_entry(tmp3,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_tc=
on,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcon_list);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_smbs_sent, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_writes, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_reads, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_oplock_brks, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_opens, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_posixopens, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_posixmkdirs, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_closes, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_deletes, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_mkdirs, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_rmdirs, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_renames, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_t2renames, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_ffirst, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_fnext, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_fclose, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_hardlinks, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_symlinks, 0);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(=
&tcon->num_locks, 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 clear_cifs_=
stats(tcon);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -307,6 +338,44 @@ static ssize_t cifs_stats_proc_write(struct f=
ile *file,
> >> =C2=A0 =C2=A0 =C2=A0 return count;
> >> =C2=A0}
> >>
> >> +static void cifs_stats_print(struct seq_file *m, struct cifs_tcon=
 *tcon)
> >> +{
> >> + =C2=A0 =C2=A0 if (tcon->need_reconnect)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_puts(m, "\tDISCONN=
ECTED ");
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->num=
_smbs_sent),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_oplock_brks));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nReads: =C2=A0%d Bytes: %lld",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_reads),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (long long)(tcon->byte=
s_read));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nWrites: %d Bytes: %lld",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_writes),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (long long)(tcon->byte=
s_written));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nFlushes: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_flushes));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks:=
 %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_locks),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_hardlinks),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_symlinks));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d"=
,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_opens),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_closes),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_deletes));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d"=
,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_posixopens),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_posixmkdirs));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_mkdirs),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_rmdirs));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nRenames: %d T2 Renames %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_renames),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_t2renames));
> >> + =C2=A0 =C2=A0 seq_printf(m, "\nFindFirst: %d FNext %d FClose %d"=
,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_ffirst),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_fnext),
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read(&tcon->sta=
ts.cifs_stats.num_fclose));
> >> +}
> >> +
> >> =C2=A0static int cifs_stats_proc_show(struct seq_file *m, void *v)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int i;
> >> @@ -354,44 +423,7 @@ static int cifs_stats_proc_show(struct seq_fi=
le *m, void *v)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcon_list);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\n%d) %s", i, tco=
n->treeName);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (tcon->need_reconnect)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_puts(m,=
 "\tDISCONNECTED ");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nSMBs: %d Oplock Breaks=
: %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_smbs_sent),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_oplock_brks));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nReads: =C2=A0%d Bytes:=
 %lld",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_reads),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (long long)=
(tcon->bytes_read));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nWrites: %d Bytes: %lld=
",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_writes),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (long long)=
(tcon->bytes_written));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nFlushes: %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_flushes));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nLocks: %d HardLinks: %=
d "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Symlinks: %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_locks),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_hardlinks),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_symlinks));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nOpens: %d Closes: %d "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Deletes: %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_opens),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_closes),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_deletes));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nPosix Opens: %d "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Posix Mkdirs: %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_posixopens),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_posixmkdirs));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nMkdirs: %d Rmdirs: %d"=
,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_mkdirs),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_rmdirs));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nRenames: %d T2 Renames=
 %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_renames),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_t2renames));
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_printf(m, "\nFindFirst: %d FNext %d=
 "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "FClose %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_ffirst),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_fnext),
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_read=
(&tcon->num_fclose));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_stats_print(m, tcon);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 4c38b04..6dfc7ef 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -292,6 +292,7 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 bool =C2=A0 =C2=A0sec_kerberos; =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 /* supports plain Kerberos */
> >> =C2=A0 =C2=A0 =C2=A0 bool =C2=A0 =C2=A0sec_mskerberos; =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* supports legacy MS Kerberos */
> >> =C2=A0 =C2=A0 =C2=A0 bool =C2=A0 =C2=A0large_buf; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* is current buffer large? */
> >> + =C2=A0 =C2=A0 bool =C2=A0 =C2=A0is_smb2; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* smb2 not cifs protocol negotiated */
> >> =C2=A0 =C2=A0 =C2=A0 struct delayed_work =C2=A0 =C2=A0 echo; /* ec=
ho ping workqueue job */
> >> =C2=A0 =C2=A0 =C2=A0 struct kvec *iov; =C2=A0 =C2=A0 =C2=A0 /* reu=
sable kvec array for receives */
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int nr_iov; =C2=A0 =C2=A0/* number o=
f kvecs in array */
> >> @@ -392,6 +393,9 @@ struct cifs_ses {
> >> =C2=A0 =C2=A0 negotiate one of the older LANMAN dialects */
> >> =C2=A0#define CIFS_SES_LANMAN 8
> >> =C2=A0#define CIFS_SES_SMB2 16
> >> +
> >> +#define NUMBER_OF_SMB2_COMMANDS 0x0013
> >> +
> >> =C2=A0/*
> >> =C2=A0 * there is one of these for each connection to a resource o=
n a particular
> >> =C2=A0 * session
> >> @@ -409,27 +413,37 @@ struct cifs_tcon {
> >> =C2=A0 =C2=A0 =C2=A0 enum statusEnum tidStatus;
> >> =C2=A0#ifdef CONFIG_CIFS_STATS
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t num_smbs_sent;
> >> - =C2=A0 =C2=A0 atomic_t num_writes;
> >> - =C2=A0 =C2=A0 atomic_t num_reads;
> >> - =C2=A0 =C2=A0 atomic_t num_flushes;
> >> - =C2=A0 =C2=A0 atomic_t num_oplock_brks;
> >> - =C2=A0 =C2=A0 atomic_t num_opens;
> >> - =C2=A0 =C2=A0 atomic_t num_closes;
> >> - =C2=A0 =C2=A0 atomic_t num_deletes;
> >> - =C2=A0 =C2=A0 atomic_t num_mkdirs;
> >> - =C2=A0 =C2=A0 atomic_t num_posixopens;
> >> - =C2=A0 =C2=A0 atomic_t num_posixmkdirs;
> >> - =C2=A0 =C2=A0 atomic_t num_rmdirs;
> >> - =C2=A0 =C2=A0 atomic_t num_renames;
> >> - =C2=A0 =C2=A0 atomic_t num_t2renames;
> >> - =C2=A0 =C2=A0 atomic_t num_ffirst;
> >> - =C2=A0 =C2=A0 atomic_t num_fnext;
> >> - =C2=A0 =C2=A0 atomic_t num_fclose;
> >> - =C2=A0 =C2=A0 atomic_t num_hardlinks;
> >> - =C2=A0 =C2=A0 atomic_t num_symlinks;
> >> - =C2=A0 =C2=A0 atomic_t num_locks;
> >> - =C2=A0 =C2=A0 atomic_t num_acl_get;
> >> - =C2=A0 =C2=A0 atomic_t num_acl_set;
> >> + =C2=A0 =C2=A0 union {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_writes;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_reads;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_flushes;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_oplock_brks;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_opens;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_closes;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_deletes;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_mkdirs;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_posixopens;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_posixmkdirs;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_rmdirs;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_renames;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_t2renames;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_ffirst;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_fnext;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_fclose;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_hardlinks;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_symlinks;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_locks;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_acl_get;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t num_acl_set;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } cifs_stats;
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_t smb2_com_fail[NUMBER_OF_SMB2_COMMANDS];
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } smb2_stats;
> >
> > Is it really necessary to do this with atomics? Those can have
> > significant performance impact (TLB flushes, and we don't seem to n=
eed the
> > guarantees that they provide for simple counters like this. Perhaps
> > these should be switched to per-cpu variables or just plain ints?
>=20
> presumably there is precedent for use of atomics rather than
> wrapping updates to these in a mutex - if they are just int
> would we have a case where the two overlapping updates could
> badly corrupt the value?
>=20

There's no need for any locking here. I think what you want is a per-cp=
u
counter for these.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
