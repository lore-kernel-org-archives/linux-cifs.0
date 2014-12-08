From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised patch to convert MessageID in smb2_hdr to LE
Date: Mon, 8 Dec 2014 16:46:36 -0600
Message-ID: <CAH2r5mtc0HzLKxOQBkn3-e3Xzw73cPFKa3QqZrrvCUxPOKH+kg@mail.gmail.com>
References: <CAH2r5msxSvtbCzPOnTpvzas5Qg46O-SJqc05GA1i2Ts74uYPtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1139bcda29bc290509bc3448
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msxSvtbCzPOnTpvzas5Qg46O-SJqc05GA1i2Ts74uYPtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a1139bcda29bc290509bc3448
Content-Type: text/plain; charset=UTF-8

Resending (attaching patch)

Redhat had encountered a problem with the SMB2/SMB3 message id (mid)
on PPC - the message id was being considered opaque and endian neutral.
Change the SMB2/SMB3 message id to be le64 on the wire (as we already
do with cifs).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2misc.c      | 12 +++++++-----
 fs/cifs/smb2ops.c       |  2 +-
 fs/cifs/smb2pdu.h       |  2 +-
 fs/cifs/smb2transport.c |  4 ++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 1a08a34..6e01933 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -32,12 +32,14 @@
 static int
 check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 {
+    __u64 wire_mid = le64_to_cpu(hdr->MessageId);
+
     /*
      * Make sure that this really is an SMB, that it is a response,
      * and that the message ids match.
      */
     if ((*(__le32 *)hdr->ProtocolId == SMB2_PROTO_NUMBER) &&
-        (mid == hdr->MessageId)) {
+        (mid == wire_mid)) {
         if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
             return 0;
         else {
@@ -51,11 +53,11 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
         if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
             cifs_dbg(VFS, "Bad protocol string signature header %x\n",
                  *(unsigned int *) hdr->ProtocolId);
-        if (mid != hdr->MessageId)
+        if (mid != wire_mid)
             cifs_dbg(VFS, "Mids do not match: %llu and %llu\n",
-                 mid, hdr->MessageId);
+                 mid, wire_mid);
     }
-    cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", hdr->MessageId);
+    cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", wire_mid);
     return 1;
 }

@@ -95,7 +97,7 @@ smb2_check_message(char *buf, unsigned int length)
 {
     struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
     struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
-    __u64 mid = hdr->MessageId;
+    __u64 mid = le64_to_cpu(hdr->MessageId);
     __u32 len = get_rfc1002_length(buf);
     __u32 clc_len;  /* calculated length */
     int command;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 568f323..e5b33d0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -179,7 +179,7 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)

     spin_lock(&GlobalMid_Lock);
     list_for_each_entry(mid, &server->pending_mid_q, qhead) {
-        if ((mid->mid == hdr->MessageId) &&
+        if ((mid->mid == le64_to_cpu(hdr->MessageId)) &&
             (mid->mid_state == MID_REQUEST_SUBMITTED) &&
             (mid->command == hdr->Command)) {
             spin_unlock(&GlobalMid_Lock);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d84f46c..2d6d388 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -110,7 +110,7 @@ struct smb2_hdr {
     __le16 CreditRequest;  /* CreditResponse */
     __le32 Flags;
     __le32 NextCommand;
-    __u64  MessageId;    /* opaque - so can stay little endian */
+    __le64  MessageId;    /* opaque - so can stay little endian */
     __le32 ProcessId;
     __u32  TreeId;        /* opaque - so do not make little endian */
     __u64  SessionId;    /* opaque - so do not make little endian */
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 5111e72..6bdee1b5 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -468,7 +468,7 @@ smb2_seq_num_into_buf(struct TCP_Server_Info
*server, struct smb2_hdr *hdr)
 {
     unsigned int i, num = le16_to_cpu(hdr->CreditCharge);

-    hdr->MessageId = get_next_mid64(server);
+    hdr->MessageId = cpu_to_le64(get_next_mid64(server));
     /* skip message numbers according to CreditCharge field */
     for (i = 1; i < num; i++)
         get_next_mid(server);
@@ -490,7 +490,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
         return temp;
     else {
         memset(temp, 0, sizeof(struct mid_q_entry));
-        temp->mid = smb_buffer->MessageId;    /* always LE */
+        temp->mid = le64_to_cpu(smb_buffer->MessageId);
         temp->pid = current->pid;
         temp->command = smb_buffer->Command;    /* Always LE */
         temp->when_alloc = jiffies;
-- 


On Mon, Dec 8, 2014 at 4:30 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Sachin,
> Since your patch had various sparse warnings, I did a different
> version, basically converting the SMB2/SMB3 MessageID field on the
> wire  to le64 from u64 (we used to assume that the MessageId/MID was
> opaque) and then modifying places that used it to match that
> endianness.
>
> Would you try that and make sure it works in your big endian
> reproduction scenario (or propose an alternate patch)?
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--001a1139bcda29bc290509bc3448
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-SMB2-Fix-SMB2-SMB3-endianness-on-PPC.patch"
Content-Disposition: attachment;
	filename="0001-SMB2-Fix-SMB2-SMB3-endianness-on-PPC.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3gfhabf0

RnJvbSA1ZjhkZWRmNTJhNzg3ZmE5MGRjYmI3YjQ1MGE3MTVlM2FhNDg3NjIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCA4IERlYyAyMDE0IDE2OjM5OjQ5IC0wNjAwClN1YmplY3Q6IFtQQVRDSF0gW1NNQjJd
IEZpeCBTTUIyL1NNQjMgZW5kaWFubmVzcyBvbiBQUEMKClJlZGhhdCBoYWQgZW5jb3VudGVyZWQg
YSBwcm9ibGVtIHdpdGggdGhlIFNNQjIvU01CMyBtZXNzYWdlIGlkIChtaWQpCm9uIFBQQyAtIHRo
ZSBtZXNzYWdlIGlkIHdhcyBiZWluZyBjb25zaWRlcmVkIG9wYXF1ZSBhbmQgZW5kaWFuIG5ldXRy
YWwuCkNoYW5nZSB0aGUgU01CMi9TTUIzIG1lc3NhZ2UgaWQgdG8gYmUgbGU2NCBvbiB0aGUgd2ly
ZSAoYXMgd2UgYWxyZWFkeQpkbyB3aXRoIGNpZnMpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+CkNDOiBTYWNoaW4gUHJhYmh1IDxzcHJhYmh1QHJlZGhh
dC5jb20+Ci0tLQogZnMvY2lmcy9zbWIybWlzYy5jICAgICAgfCAxMiArKysrKysrLS0tLS0KIGZz
L2NpZnMvc21iMm9wcy5jICAgICAgIHwgIDIgKy0KIGZzL2NpZnMvc21iMnBkdS5oICAgICAgIHwg
IDIgKy0KIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgIDQgKystLQogNCBmaWxlcyBjaGFuZ2Vk
LCAxMSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMm1pc2MuYyBiL2ZzL2NpZnMvc21iMm1pc2MuYwppbmRleCAxYTA4YTM0Li42ZTAxOTMzIDEw
MDY0NAotLS0gYS9mcy9jaWZzL3NtYjJtaXNjLmMKKysrIGIvZnMvY2lmcy9zbWIybWlzYy5jCkBA
IC0zMiwxMiArMzIsMTQgQEAKIHN0YXRpYyBpbnQKIGNoZWNrX3NtYjJfaGRyKHN0cnVjdCBzbWIy
X2hkciAqaGRyLCBfX3U2NCBtaWQpCiB7CisJX191NjQgd2lyZV9taWQgPSBsZTY0X3RvX2NwdSho
ZHItPk1lc3NhZ2VJZCk7CisKIAkvKgogCSAqIE1ha2Ugc3VyZSB0aGF0IHRoaXMgcmVhbGx5IGlz
IGFuIFNNQiwgdGhhdCBpdCBpcyBhIHJlc3BvbnNlLAogCSAqIGFuZCB0aGF0IHRoZSBtZXNzYWdl
IGlkcyBtYXRjaC4KIAkgKi8KIAlpZiAoKCooX19sZTMyICopaGRyLT5Qcm90b2NvbElkID09IFNN
QjJfUFJPVE9fTlVNQkVSKSAmJgotCSAgICAobWlkID09IGhkci0+TWVzc2FnZUlkKSkgeworCSAg
ICAobWlkID09IHdpcmVfbWlkKSkgewogCQlpZiAoaGRyLT5GbGFncyAmIFNNQjJfRkxBR1NfU0VS
VkVSX1RPX1JFRElSKQogCQkJcmV0dXJuIDA7CiAJCWVsc2UgewpAQCAtNTEsMTEgKzUzLDExIEBA
IGNoZWNrX3NtYjJfaGRyKHN0cnVjdCBzbWIyX2hkciAqaGRyLCBfX3U2NCBtaWQpCiAJCWlmICgq
KF9fbGUzMiAqKWhkci0+UHJvdG9jb2xJZCAhPSBTTUIyX1BST1RPX05VTUJFUikKIAkJCWNpZnNf
ZGJnKFZGUywgIkJhZCBwcm90b2NvbCBzdHJpbmcgc2lnbmF0dXJlIGhlYWRlciAleFxuIiwKIAkJ
CQkgKih1bnNpZ25lZCBpbnQgKikgaGRyLT5Qcm90b2NvbElkKTsKLQkJaWYgKG1pZCAhPSBoZHIt
Pk1lc3NhZ2VJZCkKKwkJaWYgKG1pZCAhPSB3aXJlX21pZCkKIAkJCWNpZnNfZGJnKFZGUywgIk1p
ZHMgZG8gbm90IG1hdGNoOiAlbGx1IGFuZCAlbGx1XG4iLAotCQkJCSBtaWQsIGhkci0+TWVzc2Fn
ZUlkKTsKKwkJCQkgbWlkLCB3aXJlX21pZCk7CiAJfQotCWNpZnNfZGJnKFZGUywgIkJhZCBTTUIg
ZGV0ZWN0ZWQuIFRoZSBNaWQ9JWxsdVxuIiwgaGRyLT5NZXNzYWdlSWQpOworCWNpZnNfZGJnKFZG
UywgIkJhZCBTTUIgZGV0ZWN0ZWQuIFRoZSBNaWQ9JWxsdVxuIiwgd2lyZV9taWQpOwogCXJldHVy
biAxOwogfQogCkBAIC05NSw3ICs5Nyw3IEBAIHNtYjJfY2hlY2tfbWVzc2FnZShjaGFyICpidWYs
IHVuc2lnbmVkIGludCBsZW5ndGgpCiB7CiAJc3RydWN0IHNtYjJfaGRyICpoZHIgPSAoc3RydWN0
IHNtYjJfaGRyICopYnVmOwogCXN0cnVjdCBzbWIyX3BkdSAqcGR1ID0gKHN0cnVjdCBzbWIyX3Bk
dSAqKWhkcjsKLQlfX3U2NCBtaWQgPSBoZHItPk1lc3NhZ2VJZDsKKwlfX3U2NCBtaWQgPSBsZTY0
X3RvX2NwdShoZHItPk1lc3NhZ2VJZCk7CiAJX191MzIgbGVuID0gZ2V0X3JmYzEwMDJfbGVuZ3Ro
KGJ1Zik7CiAJX191MzIgY2xjX2xlbjsgIC8qIGNhbGN1bGF0ZWQgbGVuZ3RoICovCiAJaW50IGNv
bW1hbmQ7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5j
CmluZGV4IDU2OGYzMjMuLmU1YjMzZDAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisr
KyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0xNzksNyArMTc5LDcgQEAgc21iMl9maW5kX21pZChz
dHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGNoYXIgKmJ1ZikKIAogCXNwaW5fbG9jaygm
R2xvYmFsTWlkX0xvY2spOwogCWxpc3RfZm9yX2VhY2hfZW50cnkobWlkLCAmc2VydmVyLT5wZW5k
aW5nX21pZF9xLCBxaGVhZCkgewotCQlpZiAoKG1pZC0+bWlkID09IGhkci0+TWVzc2FnZUlkKSAm
JgorCQlpZiAoKG1pZC0+bWlkID09IGxlNjRfdG9fY3B1KGhkci0+TWVzc2FnZUlkKSkgJiYKIAkJ
ICAgIChtaWQtPm1pZF9zdGF0ZSA9PSBNSURfUkVRVUVTVF9TVUJNSVRURUQpICYmCiAJCSAgICAo
bWlkLT5jb21tYW5kID09IGhkci0+Q29tbWFuZCkpIHsKIAkJCXNwaW5fdW5sb2NrKCZHbG9iYWxN
aWRfTG9jayk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBk
dS5oCmluZGV4IGQ4NGY0NmMuLjJkNmQzODggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5o
CisrKyBiL2ZzL2NpZnMvc21iMnBkdS5oCkBAIC0xMTAsNyArMTEwLDcgQEAgc3RydWN0IHNtYjJf
aGRyIHsKIAlfX2xlMTYgQ3JlZGl0UmVxdWVzdDsgIC8qIENyZWRpdFJlc3BvbnNlICovCiAJX19s
ZTMyIEZsYWdzOwogCV9fbGUzMiBOZXh0Q29tbWFuZDsKLQlfX3U2NCAgTWVzc2FnZUlkOwkvKiBv
cGFxdWUgLSBzbyBjYW4gc3RheSBsaXR0bGUgZW5kaWFuICovCisJX19sZTY0ICBNZXNzYWdlSWQ7
CS8qIG9wYXF1ZSAtIHNvIGNhbiBzdGF5IGxpdHRsZSBlbmRpYW4gKi8KIAlfX2xlMzIgUHJvY2Vz
c0lkOwogCV9fdTMyICBUcmVlSWQ7CQkvKiBvcGFxdWUgLSBzbyBkbyBub3QgbWFrZSBsaXR0bGUg
ZW5kaWFuICovCiAJX191NjQgIFNlc3Npb25JZDsJLyogb3BhcXVlIC0gc28gZG8gbm90IG1ha2Ug
bGl0dGxlIGVuZGlhbiAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMgYi9m
cy9jaWZzL3NtYjJ0cmFuc3BvcnQuYwppbmRleCA1MTExZTcyLi42YmRlZTFiNSAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKKysrIGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMK
QEAgLTQ2OCw3ICs0NjgsNyBAQCBzbWIyX3NlcV9udW1faW50b19idWYoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3Qgc21iMl9oZHIgKmhkcikKIHsKIAl1bnNpZ25lZCBpbnQg
aSwgbnVtID0gbGUxNl90b19jcHUoaGRyLT5DcmVkaXRDaGFyZ2UpOwogCi0JaGRyLT5NZXNzYWdl
SWQgPSBnZXRfbmV4dF9taWQ2NChzZXJ2ZXIpOworCWhkci0+TWVzc2FnZUlkID0gY3B1X3RvX2xl
NjQoZ2V0X25leHRfbWlkNjQoc2VydmVyKSk7CiAJLyogc2tpcCBtZXNzYWdlIG51bWJlcnMgYWNj
b3JkaW5nIHRvIENyZWRpdENoYXJnZSBmaWVsZCAqLwogCWZvciAoaSA9IDE7IGkgPCBudW07IGkr
KykKIAkJZ2V0X25leHRfbWlkKHNlcnZlcik7CkBAIC00OTAsNyArNDkwLDcgQEAgc21iMl9taWRf
ZW50cnlfYWxsb2MoY29uc3Qgc3RydWN0IHNtYjJfaGRyICpzbWJfYnVmZmVyLAogCQlyZXR1cm4g
dGVtcDsKIAllbHNlIHsKIAkJbWVtc2V0KHRlbXAsIDAsIHNpemVvZihzdHJ1Y3QgbWlkX3FfZW50
cnkpKTsKLQkJdGVtcC0+bWlkID0gc21iX2J1ZmZlci0+TWVzc2FnZUlkOwkvKiBhbHdheXMgTEUg
Ki8KKwkJdGVtcC0+bWlkID0gbGU2NF90b19jcHUoc21iX2J1ZmZlci0+TWVzc2FnZUlkKTsKIAkJ
dGVtcC0+cGlkID0gY3VycmVudC0+cGlkOwogCQl0ZW1wLT5jb21tYW5kID0gc21iX2J1ZmZlci0+
Q29tbWFuZDsJLyogQWx3YXlzIExFICovCiAJCXRlbXAtPndoZW5fYWxsb2MgPSBqaWZmaWVzOwot
LSAKMi4xLjAKCg==
--001a1139bcda29bc290509bc3448--
