From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v3 0/2] CIFS: Info-level log support, print message when
 attempting mount.
Date: Sun, 7 Oct 2018 13:58:48 -0500
Message-ID: <CAH2r5muEpTd4xG7oWV5BdA12AOogqscEnFdbUri9C=MFHrN_gQ@mail.gmail.com>
References: <cover.1538873915.git.rfreire@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000f772d50577a81857"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538873915.git.rfreire@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--000000000000f772d50577a81857
Content-Type: text/plain; charset="UTF-8"

Merged into cifs-2.6.git for-next

Made a trivial tab/space correction in the patch (pointed out by
checkpatch) and then added a trivial followon patch to address a
comment/style (trivial)
issue pointed out by checkpatch and to add a little more detailed
comments about generally when to use each debug function.  If any
objections let me know.


On Sun, Oct 7, 2018 at 10:21 AM Rodrigo Freire <rfreire@redhat.com> wrote:
>
> Hi Steve,
> From our conversation over v2, I came out with this v3 patch, which I broke
> in two commits:
>
> * The first commit in cifs_debug.h, creating the cifs_info() function.
>   - The aim of this commit is to allow to the developer to be able to print
>     informational-level data without having to use pr_info, pr_notice etc,
>     in line with other filesystems.
>     . One interesting and noteworthy feature of cifs_info() is that it is
>       transparent to the CIFS_DEBUG config state, either in "y" or "n".
>     . Also, by using KERN_INFO level, it can be safely filtered by a
>       maintainer / administrator, without cluttering their log monitors,
>       since this is a low level alert.
>   - I took the liberty to not add it inside the existing pr_debug, because
>     of the eventual need of some developer to print stuff that should be
>     printed not only in CIFS_DEBUG mode (as there are plenty of pr_notice
>     scattered over the code).
>   - Also, this is not a debug but a info message, so i liked cifs_info()
>     more ;-)
>   - I saw plenty of pr_notice() in CIFS code, but I resisted the urge to
>     convert them to cifs_info().
>
> * The second commit contains the code printing a cifs_info() when attempting
>   a CIFS mount operation.
>
> Appreciate your review.
>
> V3: Created a new cifs_info() function, moved the mount attempt message to
>     cifs_info
>
> V2: Created a loop to select the right cifs_dbg message to be printed,
>     considering the current system's scenario, in order to avoid a
>     duplicate message or stripping out important information in
>     debug.
>
> Rodrigo Freire (2):
>   CIFS: Adds information-level logging function
>   CIFS: Print message when attempting a mount
>
>  fs/cifs/cifs_debug.h | 16 ++++++++++++++++
>  fs/cifs/cifsfs.c     |  7 ++++++-
>  fs/cifs/transport.c  |  2 +-
>  3 files changed, 23 insertions(+), 2 deletions(-)
>
> --
> 1.8.3.1
>


-- 
Thanks,

Steve

--000000000000f772d50577a81857
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-cifs-minor-clarification-in-comments.patch"
Content-Disposition: attachment;
	filename="0001-cifs-minor-clarification-in-comments.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jmz8cyrj0>
X-Attachment-Id: f_jmz8cyrj0

RnJvbSA0YzkzOTM0NGY5NGEyNzNhMWVhYjg5Y2Y1OGY3NGM5YWQ2OGE4YThkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNyBPY3QgMjAxOCAxMzo1MjoxOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IG1pbm9yIGNsYXJpZmljYXRpb24gaW4gY29tbWVudHMKCkNsYXJpZnkgbWVhbmluZyAoaW4g
Y29tbWVudHMpIG1lYW5pbmcgb2YgdmFyaW91cwpvcHRpb25zIGZvciBkZWJ1ZyBtZXNzYWdlcyBp
biBjaWZzLmtvLiBBbHNvIGZpeGVkCnRyaXZpYWwgZm9ybWF0dGluZy9zdHlsZSBpc3N1ZSB3aXRo
IHByZXZpb3VzIHBhdGNoLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19kZWJ1Zy5oIHwgMTIgKysrKysrKysrKysr
CiBmcy9jaWZzL2NpZnNmcy5jICAgICB8ICA2ICsrKystLQogMiBmaWxlcyBjaGFuZ2VkLCAxNiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19k
ZWJ1Zy5oIGIvZnMvY2lmcy9jaWZzX2RlYnVnLmgKaW5kZXggNzJkYjI5ODdlMDY2Li42MzFkYzFi
YjIxYzEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19kZWJ1Zy5oCisrKyBiL2ZzL2NpZnMvY2lm
c19kZWJ1Zy5oCkBAIC00Nyw2ICs0NywxOCBAQCBleHRlcm4gaW50IGNpZnNGWUk7CiAgKi8KICNp
ZmRlZiBDT05GSUdfQ0lGU19ERUJVRwogCisKKy8qCisgKiBXaGVuIGFkZGluZyB0cmFjZXBvaW50
cyBhbmQgZGVidWcgbWVzc2FnZXMgd2UgaGF2ZSB2YXJpb3VzIGNob2ljZXMuCisgKiBTb21lIGNv
bnNpZGVyYXRpb25zOgorICoKKyAqIFVzZSBjaWZzX2RiZyhWRlMsIC4uLikgZm9yIHRoaW5ncyB3
ZSBhbHdheXMgd2FudCBsb2dnZWQsIGFuZCB0aGUgdXNlciB0byBzZWUKKyAqICAgICBjaWZzX2lu
Zm8oLi4uKSBzbGlnaHRseSBsZXNzIGltcG9ydGFudCwgYWRtaW4gY2FuIGZpbHRlciB2aWEgbG9n
bGV2ZWwgPiA2CisgKiAgICAgY2lmc19kYmcoRllJLCAuLi4pIG1pbm9yIGRlYnVnZ2luZyBtZXNz
YWdlcywgb2ZmIGJ5IGRlZmF1bHQKKyAqICAgICB0cmFjZV9zbWIzXyogIGZ0cmFjZSBmdW5jdGlv
bnMgYXJlIHByZWZlcnJlZCBmb3IgY29tcGxleCBkZWJ1ZyBtZXNzYWdlcworICogICAgICAgICAg
ICAgICAgIGludGVuZGVkIGZvciBkZXZlbG9wZXJzIG9yIGV4cGVyaWVuY2VkIGFkbWlucywgb2Zm
IGJ5IGRlZmF1bHQKKyAqLworCiAvKiBJbmZvcm1hdGlvbiBsZXZlbCBtZXNzYWdlcywgbWlub3Ig
ZXZlbnRzICovCiAjZGVmaW5lIGNpZnNfaW5mb19mdW5jKHJhdGVmdW5jLCBmbXQsIC4uLikJCQlc
CiBkbyB7CQkJCQkJCQlcCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9j
aWZzZnMuYwppbmRleCBkNzhhMzE1NjA5OTUuLjdkZTk2MDNjNTRmMSAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC03MTcsOCArNzE3LDEwIEBA
IGNpZnNfc21iM19kb19tb3VudChzdHJ1Y3QgZmlsZV9zeXN0ZW1fdHlwZSAqZnNfdHlwZSwKIAlz
dHJ1Y3QgY2lmc19tbnRfZGF0YSBtbnRfZGF0YTsKIAlzdHJ1Y3QgZGVudHJ5ICpyb290OwogCi0J
LyogUHJpbnRzIGluIEtlcm5lbCAvIENJRlMgbG9nIHRoZSBhdHRlbXB0ZWQgbW91bnQgb3BlcmF0
aW9uICoKLQkgKglJRiBDSUZTX0RFQlVHICYmIGNpZnNfRllJICovCisJLyoKKwkgKiBQcmludHMg
aW4gS2VybmVsIC8gQ0lGUyBsb2cgdGhlIGF0dGVtcHRlZCBtb3VudCBvcGVyYXRpb24KKwkgKglJ
ZiBDSUZTX0RFQlVHICYmIGNpZnNfRllJCisJICovCiAJaWYgKGNpZnNGWUkpCiAJCWNpZnNfZGJn
KEZZSSwgIkRldm5hbWU6ICVzIGZsYWdzOiAlZFxuIiwgZGV2X25hbWUsIGZsYWdzKTsKIAllbHNl
Ci0tIAoyLjE3LjEKCg==
--000000000000f772d50577a81857--
