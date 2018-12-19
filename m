From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix rmdir + azure + compounding regression
Date: Tue, 18 Dec 2018 22:24:01 -0600
Message-ID: <CAH2r5mt+5fUbs_USx-mejZgoM9PsmNNgLyS-Gs=OMv=iFs2e6A@mail.gmail.com>
References: <20181219035708.26546-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000f762ee057d586262"
Cc: Linux CIFS mailing list <linux-cifs@vger.kernel.org>
To: Ronnie Sahlberg <lsahlber@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181219035708.26546-1-lsahlber@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--000000000000f762ee057d586262
Content-Type: text/plain; charset="UTF-8"

Updated the patch to merge it with mine.  This will need to go in ASAP
to avoid the regression.  Running additional functional tests on it
and resending to get more eyes on it.


On Tue, Dec 18, 2018 at 9:57 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When we send a SET_INFO command for file disposition, this ends up as
> an iov of a single byte. This causes problems with SMB3 and encryption.
>
> To avoid this, instead of creating a one byte iov for the disposition value
> and then appending an additional iov with a 7 byte padding we now handle this
> as a single 8 byte iov containing both the disposition byte as well as the
> padding in one single buffer.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 14 +++++++-------
>  fs/cifs/smb2ops.c   | 23 +++++++++++++++--------
>  fs/cifs/smb2proto.h |  3 ++-
>  3 files changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 633d20b7ca03..a8999f930b22 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -97,7 +97,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>         if (rc)
>                 goto finished;
>
> -       smb2_set_next_command(server, &rqst[num_rqst++]);
> +       smb2_set_next_command(server, &rqst[num_rqst++], 0);
>
>         /* Operation */
>         switch (command) {
> @@ -111,7 +111,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                 SMB2_O_INFO_FILE, 0,
>                                 sizeof(struct smb2_file_all_info) +
>                                           PATH_MAX * 2, 0, NULL);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 0);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         case SMB2_OP_DELETE:
> @@ -134,7 +134,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, current->tgid,
>                                         FILE_DISPOSITION_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 1);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         case SMB2_OP_SET_EOF:
> @@ -149,7 +149,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, current->tgid,
>                                         FILE_END_OF_FILE_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 0);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         case SMB2_OP_SET_INFO:
> @@ -165,7 +165,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, current->tgid,
>                                         FILE_BASIC_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 0);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         case SMB2_OP_RENAME:
> @@ -189,7 +189,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, current->tgid,
>                                         FILE_RENAME_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 0);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         case SMB2_OP_HARDLINK:
> @@ -213,7 +213,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, current->tgid,
>                                         FILE_LINK_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_next_command(server, &rqst[num_rqst]);
> +               smb2_set_next_command(server, &rqst[num_rqst], 0);
>                 smb2_set_related(&rqst[num_rqst++]);
>                 break;
>         default:
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 225fec1cfa67..e25c7aade98a 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1194,7 +1194,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, path);
>         if (rc)
>                 goto iqinf_exit;
> -       smb2_set_next_command(ses->server, &rqst[0]);
> +       smb2_set_next_command(ses->server, &rqst[0], 0);
>
>         /* Query */
>         memset(&qi_iov, 0, sizeof(qi_iov));
> @@ -1208,7 +1208,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>                                   qi.output_buffer_length, buffer);
>         if (rc)
>                 goto iqinf_exit;
> -       smb2_set_next_command(ses->server, &rqst[1]);
> +       smb2_set_next_command(ses->server, &rqst[1], 0);
>         smb2_set_related(&rqst[1]);
>
>         /* Close */
> @@ -1761,16 +1761,23 @@ smb2_set_related(struct smb_rqst *rqst)
>  char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
>
>  void
> -smb2_set_next_command(struct TCP_Server_Info *server, struct smb_rqst *rqst)
> +smb2_set_next_command(struct TCP_Server_Info *server, struct smb_rqst *rqst,
> +                     bool has_space_for_padding)
>  {
>         struct smb2_sync_hdr *shdr;
>         unsigned long len = smb_rqst_len(server, rqst);
>
>         /* SMB headers in a compound are 8 byte aligned. */
>         if (len & 7) {
> -               rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
> -               rqst->rq_iov[rqst->rq_nvec].iov_len = 8 - (len & 7);
> -               rqst->rq_nvec++;
> +               if (has_space_for_padding) {
> +                       len = rqst->rq_iov[rqst->rq_nvec - 1].iov_len;
> +                       rqst->rq_iov[rqst->rq_nvec - 1].iov_len =
> +                               (len + 7) & ~7;
> +               } else {
> +                       rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
> +                       rqst->rq_iov[rqst->rq_nvec].iov_len = 8 - (len & 7);
> +                       rqst->rq_nvec++;
> +               }
>                 len = smb_rqst_len(server, rqst);
>         }
>
> @@ -1820,7 +1827,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
>         rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &srch_path);
>         if (rc)
>                 goto qfs_exit;
> -       smb2_set_next_command(server, &rqst[0]);
> +       smb2_set_next_command(server, &rqst[0], 0);
>
>         memset(&qi_iov, 0, sizeof(qi_iov));
>         rqst[1].rq_iov = qi_iov;
> @@ -1833,7 +1840,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
>                                   NULL);
>         if (rc)
>                 goto qfs_exit;
> -       smb2_set_next_command(server, &rqst[1]);
> +       smb2_set_next_command(server, &rqst[1], 0);
>         smb2_set_related(&rqst[1]);
>
>         memset(&close_iov, 0, sizeof(close_iov));
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 9f4e9ed9ce53..2fe78acd7d0c 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -117,7 +117,8 @@ extern int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
>  extern unsigned long smb_rqst_len(struct TCP_Server_Info *server,
>                                   struct smb_rqst *rqst);
>  extern void smb2_set_next_command(struct TCP_Server_Info *server,
> -                                 struct smb_rqst *rqst);
> +                                 struct smb_rqst *rqst,
> +                                 bool has_space_for_padding);
>  extern void smb2_set_related(struct smb_rqst *rqst);
>
>  /*
> --
> 2.13.6
>


-- 
Thanks,

Steve

--000000000000f762ee057d586262
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-smb3-Fix-rmdir-compounding-regression-to-strict-serv.patch"
Content-Disposition: attachment;
	filename="0001-smb3-Fix-rmdir-compounding-regression-to-strict-serv.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jpuo9fnv0>
X-Attachment-Id: f_jpuo9fnv0

RnJvbSA1MmU4YzVjNjAwN2UyMzEwZGYwOGEwNWRiYTU2MzM5M2VmOWVkOTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFR1ZSwgMTggRGVjIDIwMTggMTc6NDk6MDUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBGaXggcm1kaXIgY29tcG91bmRpbmcgcmVncmVzc2lvbiB0byBzdHJpY3Qgc2VydmVycwoK
U29tZSBzZXJ2ZXJzIHJlcXVpcmUgdGhhdCB0aGUgc2V0aW5mbyBtYXRjaGVzIHRoZSBleGFjdCBz
aXplLAphbmQgaW4gdGhpcyBjYXNlIGNvbXBvdW5kaW5nIGNoYW5nZXMgaW50cm9kdWNlZCBieQpj
b21taXQgYzJlMGZlM2Y1YWFlICgiY2lmczogbWFrZSBybWRpcigpIHVzZSBjb21wb3VuZGluZyIp
CmNhdXNlZCB1cyB0byBzZW5kIDggYnl0ZXMgKHBhZGRlZCBsZW5ndGgpIGluc3RlYWQgb2YgMSBi
eXRlCih0aGUgc2l6ZSBvZiB0aGUgc3RydWN0dXJlKS4gIFNlZSBNUy1GU0NDIHNlY3Rpb24gMi40
LjExLgoKRml4aW5nIHRoaXMgd2hlbiB3ZSBzZW5kIGEgU0VUX0lORk8gY29tbWFuZCBmb3IgZGVs
ZXRlIGZpbGUKZGlzcG9zaXRpb24sIHRoaXMgZW5kcyB1cCBhcyBhbiBpb3Ygb2YgYSBzaW5nbGUg
YnV0IHRoaXMKY2F1c2VzIHByb2JsZW1zIHdpdGggU01CMyBhbmQgZW5jcnlwdGlvbi4KClRvIGF2
b2lkIHRoaXMsIGluc3RlYWQgb2YgY3JlYXRpbmcgYSBvbmUgYnl0ZSBpb3YgZm9yIHRoZSBkaXNw
b3NpdGlvbiB2YWx1ZQphbmQgdGhlbiBhcHBlbmRpbmcgYW4gYWRkaXRpb25hbCBpb3Ygd2l0aCBh
IDcgYnl0ZSBwYWRkaW5nIHdlIG5vdyBoYW5kbGUKdGhpcyBhcyBhIHNpbmdsZSA4IGJ5dGUgaW92
IGNvbnRhaW5pbmcgYm90aCB0aGUgZGlzcG9zaXRpb24gYnl0ZSBhcyB3ZWxsIGFzCnRoZSBwYWRk
aW5nIGluIG9uZSBzaW5nbGUgYnVmZmVyLgoKU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJn
IDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyaW5vZGUuYyB8IDE2ICsrKysrKysr
LS0tLS0tLS0KIGZzL2NpZnMvc21iMm9wcy5jICAgfCAyMyArKysrKysrKysrKysrKystLS0tLS0t
LQogZnMvY2lmcy9zbWIycHJvdG8uaCB8ICAzICsrLQogMyBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNl
cnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJpbm9k
ZS5jIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwppbmRleCA5ZTdlZjdlYzJkNzAuLmE4OTk5ZjkzMGIy
MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyaW5vZGUuYworKysgYi9mcy9jaWZzL3NtYjJpbm9k
ZS5jCkBAIC05Nyw3ICs5Nyw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlpZiAocmMpCiAJCWdvdG8gZmluaXNoZWQ7
CiAKLQlzbWIyX3NldF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdCsrXSk7CisJ
c21iMl9zZXRfbmV4dF9jb21tYW5kKHNlcnZlciwgJnJxc3RbbnVtX3Jxc3QrK10sIDApOwogCiAJ
LyogT3BlcmF0aW9uICovCiAJc3dpdGNoIChjb21tYW5kKSB7CkBAIC0xMTEsNyArMTExLDcgQEAg
c21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkJCVNNQjJfT19JTkZPX0ZJTEUsIDAsCiAJCQkJc2l6ZW9mKHN0cnVjdCBzbWIy
X2ZpbGVfYWxsX2luZm8pICsKIAkJCQkJICBQQVRIX01BWCAqIDIsIDAsIE5VTEwpOwotCQlzbWIy
X3NldF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0pOworCQlzbWIyX3NldF9u
ZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0sIDApOwogCQlzbWIyX3NldF9yZWxh
dGVkKCZycXN0W251bV9ycXN0KytdKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX0RFTEVURToK
QEAgLTEyNywxNCArMTI3LDE0IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJcnFzdFtudW1fcnFzdF0ucnFfaW92ID0g
c2lfaW92OwogCQlycXN0W251bV9ycXN0XS5ycV9udmVjID0gMTsKIAotCQlzaXplWzBdID0gODsK
KwkJc2l6ZVswXSA9IDE7IC8qIHNpemVvZiBfX3U4IFNlZSBNUy1GU0NDIHNlY3Rpb24gMi40LjEx
ICovCiAJCWRhdGFbMF0gPSAmZGVsZXRlX3BlbmRpbmdbMF07CiAKIAkJcmMgPSBTTUIyX3NldF9p
bmZvX2luaXQodGNvbiwgJnJxc3RbbnVtX3Jxc3RdLCBDT01QT1VORF9GSUQsCiAJCQkJCUNPTVBP
VU5EX0ZJRCwgY3VycmVudC0+dGdpZCwKIAkJCQkJRklMRV9ESVNQT1NJVElPTl9JTkZPUk1BVElP
TiwKIAkJCQkJU01CMl9PX0lORk9fRklMRSwgMCwgZGF0YSwgc2l6ZSk7Ci0JCXNtYjJfc2V0X25l
eHRfY29tbWFuZChzZXJ2ZXIsICZycXN0W251bV9ycXN0XSk7CisJCXNtYjJfc2V0X25leHRfY29t
bWFuZChzZXJ2ZXIsICZycXN0W251bV9ycXN0XSwgMSk7CiAJCXNtYjJfc2V0X3JlbGF0ZWQoJnJx
c3RbbnVtX3Jxc3QrK10pOwogCQlicmVhazsKIAljYXNlIFNNQjJfT1BfU0VUX0VPRjoKQEAgLTE0
OSw3ICsxNDksNyBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJCUNPTVBPVU5EX0ZJRCwgY3VycmVudC0+dGdpZCwK
IAkJCQkJRklMRV9FTkRfT0ZfRklMRV9JTkZPUk1BVElPTiwKIAkJCQkJU01CMl9PX0lORk9fRklM
RSwgMCwgZGF0YSwgc2l6ZSk7Ci0JCXNtYjJfc2V0X25leHRfY29tbWFuZChzZXJ2ZXIsICZycXN0
W251bV9ycXN0XSk7CisJCXNtYjJfc2V0X25leHRfY29tbWFuZChzZXJ2ZXIsICZycXN0W251bV9y
cXN0XSwgMCk7CiAJCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOwogCQlicmVh
azsKIAljYXNlIFNNQjJfT1BfU0VUX0lORk86CkBAIC0xNjUsNyArMTY1LDcgQEAgc21iMl9jb21w
b3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CQkJCQlDT01QT1VORF9GSUQsIGN1cnJlbnQtPnRnaWQsCiAJCQkJCUZJTEVfQkFTSUNfSU5GT1JN
QVRJT04sCiAJCQkJCVNNQjJfT19JTkZPX0ZJTEUsIDAsIGRhdGEsIHNpemUpOwotCQlzbWIyX3Nl
dF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0pOworCQlzbWIyX3NldF9uZXh0
X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0sIDApOwogCQlzbWIyX3NldF9yZWxhdGVk
KCZycXN0W251bV9ycXN0KytdKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1JFTkFNRToKQEAg
LTE4OSw3ICsxODksNyBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJCUNPTVBPVU5EX0ZJRCwgY3VycmVudC0+dGdp
ZCwKIAkJCQkJRklMRV9SRU5BTUVfSU5GT1JNQVRJT04sCiAJCQkJCVNNQjJfT19JTkZPX0ZJTEUs
IDAsIGRhdGEsIHNpemUpOwotCQlzbWIyX3NldF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtu
dW1fcnFzdF0pOworCQlzbWIyX3NldF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFz
dF0sIDApOwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKIAkJYnJlYWs7
CiAJY2FzZSBTTUIyX09QX0hBUkRMSU5LOgpAQCAtMjEzLDcgKzIxMyw3IEBAIHNtYjJfY29tcG91
bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJ
CQkJQ09NUE9VTkRfRklELCBjdXJyZW50LT50Z2lkLAogCQkJCQlGSUxFX0xJTktfSU5GT1JNQVRJ
T04sCiAJCQkJCVNNQjJfT19JTkZPX0ZJTEUsIDAsIGRhdGEsIHNpemUpOwotCQlzbWIyX3NldF9u
ZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0pOworCQlzbWIyX3NldF9uZXh0X2Nv
bW1hbmQoc2VydmVyLCAmcnFzdFtudW1fcnFzdF0sIDApOwogCQlzbWIyX3NldF9yZWxhdGVkKCZy
cXN0W251bV9ycXN0KytdKTsKIAkJYnJlYWs7CiAJZGVmYXVsdDoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggMjI1ZmVjMWNmYTY3Li5lMjVj
N2FhZGU5OGEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCkBAIC0xMTk0LDcgKzExOTQsNyBAQCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwKIAlyYyA9IFNNQjJfb3Blbl9pbml0KHRjb24sICZycXN0WzBdLCAm
b3Bsb2NrLCAmb3Bhcm1zLCBwYXRoKTsKIAlpZiAocmMpCiAJCWdvdG8gaXFpbmZfZXhpdDsKLQlz
bWIyX3NldF9uZXh0X2NvbW1hbmQoc2VzLT5zZXJ2ZXIsICZycXN0WzBdKTsKKwlzbWIyX3NldF9u
ZXh0X2NvbW1hbmQoc2VzLT5zZXJ2ZXIsICZycXN0WzBdLCAwKTsKIAogCS8qIFF1ZXJ5ICovCiAJ
bWVtc2V0KCZxaV9pb3YsIDAsIHNpemVvZihxaV9pb3YpKTsKQEAgLTEyMDgsNyArMTIwOCw3IEBA
IHNtYjJfaW9jdGxfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAogCQkJCSAgcWku
b3V0cHV0X2J1ZmZlcl9sZW5ndGgsIGJ1ZmZlcik7CiAJaWYgKHJjKQogCQlnb3RvIGlxaW5mX2V4
aXQ7Ci0Jc21iMl9zZXRfbmV4dF9jb21tYW5kKHNlcy0+c2VydmVyLCAmcnFzdFsxXSk7CisJc21i
Ml9zZXRfbmV4dF9jb21tYW5kKHNlcy0+c2VydmVyLCAmcnFzdFsxXSwgMCk7CiAJc21iMl9zZXRf
cmVsYXRlZCgmcnFzdFsxXSk7CiAKIAkvKiBDbG9zZSAqLwpAQCAtMTc2MSwxNiArMTc2MSwyMyBA
QCBzbWIyX3NldF9yZWxhdGVkKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCkKIGNoYXIgc21iMl9wYWRk
aW5nWzddID0gezAsIDAsIDAsIDAsIDAsIDAsIDB9OwogCiB2b2lkCi1zbWIyX3NldF9uZXh0X2Nv
bW1hbmQoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJx
c3QpCitzbWIyX3NldF9uZXh0X2NvbW1hbmQoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
LCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsCisJCSAgICAgIGJvb2wgaGFzX3NwYWNlX2Zvcl9wYWRk
aW5nKQogewogCXN0cnVjdCBzbWIyX3N5bmNfaGRyICpzaGRyOwogCXVuc2lnbmVkIGxvbmcgbGVu
ID0gc21iX3Jxc3RfbGVuKHNlcnZlciwgcnFzdCk7CiAKIAkvKiBTTUIgaGVhZGVycyBpbiBhIGNv
bXBvdW5kIGFyZSA4IGJ5dGUgYWxpZ25lZC4gKi8KIAlpZiAobGVuICYgNykgewotCQlycXN0LT5y
cV9pb3ZbcnFzdC0+cnFfbnZlY10uaW92X2Jhc2UgPSBzbWIyX3BhZGRpbmc7Ci0JCXJxc3QtPnJx
X2lvdltycXN0LT5ycV9udmVjXS5pb3ZfbGVuID0gOCAtIChsZW4gJiA3KTsKLQkJcnFzdC0+cnFf
bnZlYysrOworCQlpZiAoaGFzX3NwYWNlX2Zvcl9wYWRkaW5nKSB7CisJCQlsZW4gPSBycXN0LT5y
cV9pb3ZbcnFzdC0+cnFfbnZlYyAtIDFdLmlvdl9sZW47CisJCQlycXN0LT5ycV9pb3ZbcnFzdC0+
cnFfbnZlYyAtIDFdLmlvdl9sZW4gPQorCQkJCShsZW4gKyA3KSAmIH43OworCQl9IGVsc2Ugewor
CQkJcnFzdC0+cnFfaW92W3Jxc3QtPnJxX252ZWNdLmlvdl9iYXNlID0gc21iMl9wYWRkaW5nOwor
CQkJcnFzdC0+cnFfaW92W3Jxc3QtPnJxX252ZWNdLmlvdl9sZW4gPSA4IC0gKGxlbiAmIDcpOwor
CQkJcnFzdC0+cnFfbnZlYysrOworCQl9CiAJCWxlbiA9IHNtYl9ycXN0X2xlbihzZXJ2ZXIsIHJx
c3QpOwogCX0KIApAQCAtMTgyMCw3ICsxODI3LDcgQEAgc21iMl9xdWVyeWZzKGNvbnN0IHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcmMgPSBTTUIyX29wZW5faW5p
dCh0Y29uLCAmcnFzdFswXSwgJm9wbG9jaywgJm9wYXJtcywgJnNyY2hfcGF0aCk7CiAJaWYgKHJj
KQogCQlnb3RvIHFmc19leGl0OwotCXNtYjJfc2V0X25leHRfY29tbWFuZChzZXJ2ZXIsICZycXN0
WzBdKTsKKwlzbWIyX3NldF9uZXh0X2NvbW1hbmQoc2VydmVyLCAmcnFzdFswXSwgMCk7CiAKIAlt
ZW1zZXQoJnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lvdikpOwogCXJxc3RbMV0ucnFfaW92ID0gcWlf
aW92OwpAQCAtMTgzMyw3ICsxODQwLDcgQEAgc21iMl9xdWVyeWZzKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJICBOVUxMKTsKIAlpZiAocmMpCiAJ
CWdvdG8gcWZzX2V4aXQ7Ci0Jc21iMl9zZXRfbmV4dF9jb21tYW5kKHNlcnZlciwgJnJxc3RbMV0p
OworCXNtYjJfc2V0X25leHRfY29tbWFuZChzZXJ2ZXIsICZycXN0WzFdLCAwKTsKIAlzbWIyX3Nl
dF9yZWxhdGVkKCZycXN0WzFdKTsKIAogCW1lbXNldCgmY2xvc2VfaW92LCAwLCBzaXplb2YoY2xv
c2VfaW92KSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIy
cHJvdG8uaAppbmRleCA5ZjRlOWVkOWNlNTMuLjJmZTc4YWNkN2QwYyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9zbWIycHJvdG8uaAorKysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC0xMTcsNyArMTE3
LDggQEAgZXh0ZXJuIGludCBzbWIzX2NyeXB0b19hZWFkX2FsbG9jYXRlKHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlcik7CiBleHRlcm4gdW5zaWduZWQgbG9uZyBzbWJfcnFzdF9sZW4oc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJCSAgc3RydWN0IHNtYl9ycXN0ICpycXN0
KTsKIGV4dGVybiB2b2lkIHNtYjJfc2V0X25leHRfY29tbWFuZChzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIsCi0JCQkJICBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOworCQkJCSAgc3RydWN0
IHNtYl9ycXN0ICpycXN0LAorCQkJCSAgYm9vbCBoYXNfc3BhY2VfZm9yX3BhZGRpbmcpOwogZXh0
ZXJuIHZvaWQgc21iMl9zZXRfcmVsYXRlZChzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOwogCiAvKgot
LSAKMi4xNy4xCgo=
--000000000000f762ee057d586262--
