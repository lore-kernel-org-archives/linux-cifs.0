From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2 02/53] CIFS: Allow SMB2 statistics to be tracked
Date: Sat, 29 Oct 2011 00:12:45 -0500
Message-ID: <CAH2r5mtpckA75LEAynsPLVsPfr7U0wnYAyZ1uKeK2VU9F1CGeQ@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-3-git-send-email-piastry@etersoft.ru>
	<20111029004814.41340503@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry@etersoft.ru>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Steve French <sfrench@us.ibm.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111029004814.41340503@corrin.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Oct 28, 2011 at 11:48 PM, Jeff Layton <jlayton@samba.org> wrote=
:
> On Fri, 28 Oct 2011 23:54:13 +0400
> Pavel Shilovsky <piastry@etersoft.ru> wrote:
>
>> From: Steve French <sfrench@us.ibm.com>
>>
>> Adding SMB2 statistics requires changes to the way cifs handles stat=
s.
>> Since there are only 19 command codes, it also is easier to track by=
 exact
>> command code than it was for cifs. =A0Turn the counters for protocol
>> ops sent to be a union (one struct for cifs, one for smb2). =A0While=
 at it
>> split out the functions which clear stats and prints stats into thei=
r own
>> subfunctions so they are easy to read and don't go past 80 columns.
>>
>> Signed-off-by: Steve French <sfrench@us.ibm.com>
>> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> ---
>> =A0fs/cifs/cifs_debug.c | =A0146 ++++++++++++++++++++++++++++++-----=
--------------
>> =A0fs/cifs/cifsglob.h =A0 | =A0 56 ++++++++++++-------
>> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 54 +++++++++---------
>> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0 =A02 +-
>> =A04 files changed, 152 insertions(+), 106 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 84e8c07..8ccdb15 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -249,6 +249,55 @@ static const struct file_operations cifs_debug_=
data_proc_fops =3D {
>> =A0};
>>
>> =A0#ifdef CONFIG_CIFS_STATS
>> +
>> +#ifdef CONFIG_CIFS_SMB2
>> +static void smb2_clear_stats(struct cifs_tcon *tcon)
>> +{
>> + =A0 =A0 int i;
>> +
>> + =A0 =A0 atomic_set(&tcon->num_smbs_sent, 0);
>> + =A0 =A0 for (i =3D 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&tcon->stats.smb2_stats.smb2_co=
m_sent[i], 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&tcon->stats.smb2_stats.smb2_co=
m_fail[i], 0);
>> + =A0 =A0 }
>> +}
>> +#endif /* CONFIG_CIFS_SMB2 */
>> +
>> +static void clear_cifs_stats(struct cifs_tcon *tcon)
>> +{
>> + =A0 =A0 atomic_set(&tcon->num_smbs_sent, 0);
>> +
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 if (tcon->ses->server->is_smb2) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 smb2_clear_stats(tcon);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 }
>> +#endif /* CONFIG_CIFS_SMB2 */
>> +
>
> =A0 =A0 ^^^^^^^^^^^^^
> The above logic should be encapsulated in smb2_clear_stats, and that
> function should just be a noop when CONFIG_CIFS_SMB2 is not set.

makes sense - could be easier to read your way


>> + =A0 =A0 /* cifs specific statistics, not applicable to smb2 sessio=
ns */
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_writes, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_reads, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_flushes, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_oplock_brks, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_opens, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_posixopens, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_closes, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_deletes, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_mkdirs, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_rmdirs, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_renames, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_t2renames, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_ffirst, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_fnext, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_fclose, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_hardlinks, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_symlinks, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_locks, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_acl_get, 0);
>> + =A0 =A0 atomic_set(&tcon->stats.cifs_stats.num_acl_set, 0);
>> +}
>> +
>> =A0static ssize_t cifs_stats_proc_write(struct file *file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char __user *buffer, size_t count,=
 loff_t *ppos)
>> =A0{
>> @@ -279,25 +328,7 @@ static ssize_t cifs_stats_proc_write(struct fil=
e *file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 tcon =3D list_entry(tmp3,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon_list);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_smbs_sent, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_writes, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_reads, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_oplock_brks, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_opens, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_posixopens, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_posixmkdirs, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_closes, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_deletes, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_mkdirs, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_rmdirs, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_renames, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_t2renames, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_ffirst, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_fnext, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_fclose, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_hardlinks, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_symlinks, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_set(&tcon->num_locks, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 clear_cifs_stats(tcon);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -307,6 +338,44 @@ static ssize_t cifs_stats_proc_write(struct fil=
e *file,
>> =A0 =A0 =A0 return count;
>> =A0}
>>
>> +static void cifs_stats_print(struct seq_file *m, struct cifs_tcon *=
tcon)
>> +{
>> + =A0 =A0 if (tcon->need_reconnect)
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(m, "\tDISCONNECTED ");
>> + =A0 =A0 seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->num_smbs_sent),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_op=
lock_brks));
>> + =A0 =A0 seq_printf(m, "\nReads: =A0%d Bytes: %lld",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_re=
ads),
>> + =A0 =A0 =A0 =A0 =A0 =A0 (long long)(tcon->bytes_read));
>> + =A0 =A0 seq_printf(m, "\nWrites: %d Bytes: %lld",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_wr=
ites),
>> + =A0 =A0 =A0 =A0 =A0 =A0 (long long)(tcon->bytes_written));
>> + =A0 =A0 seq_printf(m, "\nFlushes: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_fl=
ushes));
>> + =A0 =A0 seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_lo=
cks),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_ha=
rdlinks),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_sy=
mlinks));
>> + =A0 =A0 seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_op=
ens),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_cl=
oses),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_de=
letes));
>> + =A0 =A0 seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_po=
sixopens),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_po=
sixmkdirs));
>> + =A0 =A0 seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_mk=
dirs),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_rm=
dirs));
>> + =A0 =A0 seq_printf(m, "\nRenames: %d T2 Renames %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_re=
names),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_t2=
renames));
>> + =A0 =A0 seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_ff=
irst),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_fn=
ext),
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&tcon->stats.cifs_stats.num_fc=
lose));
>> +}
>> +
>> =A0static int cifs_stats_proc_show(struct seq_file *m, void *v)
>> =A0{
>> =A0 =A0 =A0 int i;
>> @@ -354,44 +423,7 @@ static int cifs_stats_proc_show(struct seq_file=
 *m, void *v)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon_list);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_prin=
tf(m, "\n%d) %s", i, tcon->treeName);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->=
need_reconnect)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 seq_puts(m, "\tDISCONNECTED ");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nSMBs: %d Oplock Breaks: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_smbs_sent),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_oplock_brks));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nReads: =A0%d Bytes: %lld",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_reads),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (long long)(tcon->bytes_read));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nWrites: %d Bytes: %lld",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_writes),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (long long)(tcon->bytes_written));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nFlushes: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_flushes));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nLocks: %d HardLinks: %d "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 "Symlinks: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_locks),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_hardlinks),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_symlinks));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nOpens: %d Closes: %d "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 "Deletes: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_opens),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_closes),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_deletes));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nPosix Opens: %d "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 "Posix Mkdirs: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_posixopens),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_posixmkdirs));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nMkdirs: %d Rmdirs: %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_mkdirs),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_rmdirs));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nRenames: %d T2 Renames %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_renames),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_t2renames));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf=
(m, "\nFindFirst: %d FNext %d "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 "FClose %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_ffirst),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_fnext),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 atomic_read(&tcon->num_fclose));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats=
_print(m, tcon);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 4c38b04..6dfc7ef 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -292,6 +292,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* support=
s plain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0large_buf; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* is =
current buffer large? */
>> + =A0 =A0 bool =A0 =A0is_smb2; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* smb=
2 not cifs protocol negotiated */
>> =A0 =A0 =A0 struct delayed_work =A0 =A0 echo; /* echo ping workqueue=
 job */
>> =A0 =A0 =A0 struct kvec *iov; =A0 =A0 =A0 /* reusable kvec array for=
 receives */
>> =A0 =A0 =A0 unsigned int nr_iov; =A0 =A0/* number of kvecs in array =
*/
>> @@ -392,6 +393,9 @@ struct cifs_ses {
>> =A0 =A0 negotiate one of the older LANMAN dialects */
>> =A0#define CIFS_SES_LANMAN 8
>> =A0#define CIFS_SES_SMB2 16
>> +
>> +#define NUMBER_OF_SMB2_COMMANDS 0x0013
>> +
>> =A0/*
>> =A0 * there is one of these for each connection to a resource on a p=
articular
>> =A0 * session
>> @@ -409,27 +413,37 @@ struct cifs_tcon {
>> =A0 =A0 =A0 enum statusEnum tidStatus;
>> =A0#ifdef CONFIG_CIFS_STATS
>> =A0 =A0 =A0 atomic_t num_smbs_sent;
>> - =A0 =A0 atomic_t num_writes;
>> - =A0 =A0 atomic_t num_reads;
>> - =A0 =A0 atomic_t num_flushes;
>> - =A0 =A0 atomic_t num_oplock_brks;
>> - =A0 =A0 atomic_t num_opens;
>> - =A0 =A0 atomic_t num_closes;
>> - =A0 =A0 atomic_t num_deletes;
>> - =A0 =A0 atomic_t num_mkdirs;
>> - =A0 =A0 atomic_t num_posixopens;
>> - =A0 =A0 atomic_t num_posixmkdirs;
>> - =A0 =A0 atomic_t num_rmdirs;
>> - =A0 =A0 atomic_t num_renames;
>> - =A0 =A0 atomic_t num_t2renames;
>> - =A0 =A0 atomic_t num_ffirst;
>> - =A0 =A0 atomic_t num_fnext;
>> - =A0 =A0 atomic_t num_fclose;
>> - =A0 =A0 atomic_t num_hardlinks;
>> - =A0 =A0 atomic_t num_symlinks;
>> - =A0 =A0 atomic_t num_locks;
>> - =A0 =A0 atomic_t num_acl_get;
>> - =A0 =A0 atomic_t num_acl_set;
>> + =A0 =A0 union {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_writes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_reads;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_flushes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_oplock_brks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_opens;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_closes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_deletes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_mkdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixopens;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixmkdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_rmdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_renames;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_t2renames;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_ffirst;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fnext;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fclose;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_hardlinks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_symlinks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_locks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_get;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_set;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } cifs_stats;
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_sent[NUM=
BER_OF_SMB2_COMMANDS];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_fail[NUM=
BER_OF_SMB2_COMMANDS];
>> + =A0 =A0 =A0 =A0 =A0 =A0 } smb2_stats;
>
> Is it really necessary to do this with atomics? Those can have
> significant performance impact (TLB flushes, and we don't seem to nee=
d the
> guarantees that they provide for simple counters like this. Perhaps
> these should be switched to per-cpu variables or just plain ints?

presumably there is precedent for use of atomics rather than
wrapping updates to these in a mutex - if they are just int
would we have a case where the two overlapping updates could
badly corrupt the value?


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
