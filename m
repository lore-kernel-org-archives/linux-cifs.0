From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/3] s390x: fix condition to choose correct function
Date: Mon, 29 Feb 2016 18:09:52 -0600
Message-ID: <CAH2r5mtv+PNtHu1gyEwZCdXmsoTHNG0YC-Xx3JXqWYpA=T9g9g@mail.gmail.com>
References: <smfrench@gmail.com> <1456790652-92638-1-git-send-email-smfrench@gmail.com>
 <CAH2r5ms0Ntg5OhvGYrvXLBVZkhjhF9N4jBqxR4iJDvMn3FqV6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113ea6c2c53871052cf196d3
Cc: Yadan Fan <ydfan@suse.com>, Steve French <smfrench@gmail.com>,
	stable <stable@vger.kernel.org>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAH2r5ms0Ntg5OhvGYrvXLBVZkhjhF9N4jBqxR4iJDvMn3FqV6A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--001a113ea6c2c53871052cf196d3
Content-Type: text/plain; charset=UTF-8

Ignore the last one I sent - it was the wrong one.  The correct
version (the one I merged into cifs-2.6.git) is attached.



On Mon, Feb 29, 2016 at 6:05 PM, Steve French <smfrench@gmail.com> wrote:
> Yadan,
> I updated the patch to fix whitespace problems and made trivial
> changes to commit description.  Would you doublecheck that it is what
> you want?
>
> Patch is merged into cifs-2.6.git
>
> On Mon, Feb 29, 2016 at 6:04 PM, Steve French <smfrench@gmail.com> wrote:
>> From: Yadan Fan <ydfan@suse.com>
>>
>> This issue is involved from commit 02323db17e3a7 ("cifs: fix
>> cifs_uniqueid_to_ino_t not to ever return 0"), when BITS_PER_LONG
>> is 64 on s390x, the corresponding cifs_uniqueid_to_ino_t()
>> function will cast 64-bit fileid to 32-bit by using (ino_t)fileid,
>> because ino_t (typdefed __kernel_ino_t) is int type.
>>
>> Signed-off-by: Yadan Fan <ydfan@suse.com>
>> Signed-off-by: Steve French <smfrench@gmail.com>
>> CC: stable <stable@vger.kernel.org>
>> ---
>>  fs/cifs/cifsfs.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index 68c4547..02dcbe1 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -31,7 +31,7 @@
>>   * so that it will fit. We use hash_64 to convert the value to 31 bits, and
>>   * then add 1, to ensure that we don't end up with a 0 as the value.
>>   */
>> -#if BITS_PER_LONG == 64
>> +#if BITS_PER_LONG == 64 && !defined(CONFIG_S390)
>>  static inline ino_t
>>  cifs_uniqueid_to_ino_t(u64 fileid)
>>  {
>> --
>> 1.9.1
>>
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

--001a113ea6c2c53871052cf196d3
Content-Type: application/mbox;
	name="0001-Fix-cifs_uniqueid_to_ino_t-function-for-s390x.patch"
Content-Disposition: attachment;
	filename="0001-Fix-cifs_uniqueid_to_ino_t-function-for-s390x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_il8nqp270

RnJvbSAxZWU5ZjRiZDFhOTcwMjZhN2IyZDdhZTlmMWY3NGI0NTY4MGQwMDAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZYWRhbiBGYW4gPHlkZmFuQG5vdmVsbC5jb20+CkRhdGU6IE1v
biwgMjkgRmViIDIwMTYgMTQ6NDQ6NTcgKzA4MDAKU3ViamVjdDogW1BBVENIIDEvMl0gRml4IGNp
ZnNfdW5pcXVlaWRfdG9faW5vX3QoKSBmdW5jdGlvbiBmb3IgczM5MHgKClRoaXMgaXNzdWUgaXMg
Y2F1c2VkIGJ5IGNvbW1pdCAwMjMyM2RiMTdlM2E3ICgiY2lmczogZml4CmNpZnNfdW5pcXVlaWRf
dG9faW5vX3Qgbm90IHRvIGV2ZXIgcmV0dXJuIDAiKSwgd2hlbiBCSVRTX1BFUl9MT05HCmlzIDY0
IG9uIHMzOTB4LCB0aGUgY29ycmVzcG9uZGluZyBjaWZzX3VuaXF1ZWlkX3RvX2lub190KCkKZnVu
Y3Rpb24gd2lsbCBjYXN0IDY0LWJpdCBmaWxlaWQgdG8gMzItYml0IGJ5IHVzaW5nIChpbm9fdClm
aWxlaWQsCmJlY2F1c2UgaW5vX3QgKHR5cGRlZmVkIF9fa2VybmVsX2lub190KSBpcyBpbnQgdHlw
ZS4KCkl0J3MgZGVmaW5lZCBpbiBhcmNoL3MzOTAvaW5jbHVkZS91YXBpL2FzbS9wb3NpeF90eXBl
cy5oCgogICAgI2lmbmRlZiBfX3MzOTB4X18KCiAgICB0eXBlZGVmIHVuc2lnbmVkIGxvbmcgICBf
X2tlcm5lbF9pbm9fdDsKICAgIC4uLgogICAgI2Vsc2UgLyogX19zMzkweF9fICovCgogICAgdHlw
ZWRlZiB1bnNpZ25lZCBpbnQgICAgX19rZXJuZWxfaW5vX3Q7CgpTbyB0aGUgI2lmZGVmIGNvbmRp
dGlvbiBpcyB3cm9uZyBmb3IgczM5MHgsIHdlIGNhbiBqdXN0IHN0aWxsIHVzZQpvbmUgY2lmc191
bmlxdWVpZF90b19pbm9fdCgpIGZ1bmN0aW9uIHdpdGggY29tcGFyaW5nIHNpemVvZihpbm9fdCkK
YW5kIHNpemVvZih1NjQpIHRvIGNob29zZSB0aGUgY29ycmVjdCBleGVjdXRpb24gYWNjb3JkaW5n
bHkuCgpTaWduZWQtb2ZmLWJ5OiBZYWRhbiBGYW4gPHlkZmFuQHN1c2UuY29tPgpDQzogc3RhYmxl
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNt
ZnJlbmNoQGdtYWlsLmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5oIHwgMTIgKysrKy0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmggYi9mcy9jaWZzL2NpZnNmcy5oCmluZGV4IDY4YzQ1NDcu
LjgzYWFjOGIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmgKKysrIGIvZnMvY2lmcy9jaWZz
ZnMuaApAQCAtMzEsMTkgKzMxLDE1IEBACiAgKiBzbyB0aGF0IGl0IHdpbGwgZml0LiBXZSB1c2Ug
aGFzaF82NCB0byBjb252ZXJ0IHRoZSB2YWx1ZSB0byAzMSBiaXRzLCBhbmQKICAqIHRoZW4gYWRk
IDEsIHRvIGVuc3VyZSB0aGF0IHdlIGRvbid0IGVuZCB1cCB3aXRoIGEgMCBhcyB0aGUgdmFsdWUu
CiAgKi8KLSNpZiBCSVRTX1BFUl9MT05HID09IDY0CiBzdGF0aWMgaW5saW5lIGlub190CiBjaWZz
X3VuaXF1ZWlkX3RvX2lub190KHU2NCBmaWxlaWQpCiB7CisJaWYgKChzaXplb2YoaW5vX3QpKSA8
IChzaXplb2YodTY0KSkpCisJCXJldHVybiAoaW5vX3QpaGFzaF82NChmaWxlaWQsIChzaXplb2Yo
aW5vX3QpICogOCkgLSAxKSArIDE7CisKIAlyZXR1cm4gKGlub190KWZpbGVpZDsKKwogfQotI2Vs
c2UKLXN0YXRpYyBpbmxpbmUgaW5vX3QKLWNpZnNfdW5pcXVlaWRfdG9faW5vX3QodTY0IGZpbGVp
ZCkKLXsKLQlyZXR1cm4gKGlub190KWhhc2hfNjQoZmlsZWlkLCAoc2l6ZW9mKGlub190KSAqIDgp
IC0gMSkgKyAxOwotfQotI2VuZGlmCiAKIGV4dGVybiBzdHJ1Y3QgZmlsZV9zeXN0ZW1fdHlwZSBj
aWZzX2ZzX3R5cGU7CiBleHRlcm4gY29uc3Qgc3RydWN0IGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9u
cyBjaWZzX2FkZHJfb3BzOwotLSAKMS45LjEKCg==
--001a113ea6c2c53871052cf196d3--
