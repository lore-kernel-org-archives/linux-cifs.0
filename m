From: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Subject: Re: [PATCH] cifs: don't instantiate new dentries in readdir for inodes
 that need to be revalidated immediately
Date: Mon, 12 Aug 2013 08:07:29 +0200
Message-ID: <52087BA1.4020307@gmx.ch>
References: <51F92F0B.7030504@cam.ac.uk> <1375880647-22512-1-git-send-email-jlayton@redhat.com> <20130807090616.6ba44d6c@tlielax.poochiereds.net> <52024EC3.2070504@cam.ac.uk> <5203A5B8.80600@gmx.ch> <20130808102236.44424bf3@tlielax.poochiereds.net> <CAH2r5muc+5xpabeQYNJq5Vb2_2nAMof2EUUFbkMpoBsUX7MC+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010006050206030408020704"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muc+5xpabeQYNJq5Vb2_2nAMof2EUUFbkMpoBsUX7MC+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms010006050206030408020704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 08.08.2013 17:33, schrieb Steve French:
> On Thu, Aug 8, 2013 at 9:22 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:=

>> On Thu, 08 Aug 2013 16:05:44 +0200
>> Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>>
>>> Am 07.08.2013 15:42, schrieb David McBride:
>>>> On 07/08/13 14:06, Jeff Layton wrote:
>>>>
>>>>> This patch is untested (other than for compilation), but I think it=
'll
>>>>> do the right thing. Metze, David could you test it and let us know =
if
>>>>> it helps?
>>>
>>> Just to verify: could it be that mfsymlink is already broken in
>>> 3.9.6-301.fc19? At least links created with fedora 18 are no longer
>>> readable there. Newly created links seems to work fine (at least till=
 now).
>>>
>>> Greets
>>> Marcus
>>>
>>
>> Yes, 3.9.6 has the patch that broke it.
>>
>> What matters is how the (in memory) inode is created after mounting. I=
f
>> you first run across an mfsymlink with a readdir() call, then you'll
>> get an inode that's "stuck" as a regular file. If you instead do
>> something like stat() it before ever running a readdir over the
>> containing directory, it should work just fine.
>>
>> This patch probably is probably reasonable for stable, given that the
>> original one also went there.
>>
>> Steve, want to mark as such?

@Jeff, could you please do me a favor and let me know, when this is=20
stable/made it to Fedora, as we are in need of that patch.

Thanks
Marcus



--------------ms010006050206030408020704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFvTCC
BbkwggOhoAMCAQICAw1DyzANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMzA1
MjMwODU0MzRaFw0xNTA1MjMwODU0MzRaMGUxFzAVBgNVBAMTDk1hcmN1cyBNb2VsbGVyMSQw
IgYJKoZIhvcNAQkBFhVtYXJjdXMubW9lbGxlckBnbXguY2gxJDAiBgkqhkiG9w0BCQEWFW1h
aWxAbWFyY3VzbW9lbGxlci5jaDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALIV
a7K9tFzUNGmvyXzEMYY4SS7WPfvKjqswJ+Gd4WkhYsNkwBDNRteJB8t4eidHEM6Dc75AZb62
NHrTqpQ+3wWgzJtv2EW35XtiIxKGCkAuI80szBhwNgPSJpuaaSkcM3PIPEjxmg5KBOzYh0F+
myHjzgsuOgoSYSk+Ta0T5s3dL0PZlyEHoZf981nl5pN/K60Nc8q3XVimR1F3dcc4QB6UCFyI
Nshnph4iecKsje0AsoUmSsRbGPlsKAB4UxZIV2KFZHdefkG6pO0vai0wqJi/Wo2S2Xo60t+N
jcMW7qgyYQ5Pjz+ViCW0vBTAwRc1Kx/45qQaNP8m57NQMZaT3RsCAwEAAaOCAVwwggFYMAwG
A1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0
ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB
/wQEAwIDqDBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisG
AQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6
Ly9vY3NwLmNhY2VydC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQu
b3JnL3Jldm9rZS5jcmwwNwYDVR0RBDAwLoEVbWFyY3VzLm1vZWxsZXJAZ214LmNogRVtYWls
QG1hcmN1c21vZWxsZXIuY2gwDQYJKoZIhvcNAQEFBQADggIBAF5iT90wb8r/9weOFQQ2rRK2
Bowrd3LA7TtAZdmRebgfAZoS4wVQJnvlp8sKN9J/WkaLyOmwHcMlFgJVLVTZERpPF/fsf95T
EKBHjxQIn4VH1zfIy/W7hURS7BFh2AFHktQ/O0zUiWJ1h1icdlxp4hjIkiUvVKZWnYy2THp/
3DTgH52pIUBFtc+kKRPiip/KTcD9X8I7QLGzBJMdpw8mA3PkxT0I4aW564xN0Hxx0ds/ksBl
X9IBRA+J2D977E6+/buuLXQbGWZla2Pr8ClHZ0uq0NMYg6+E+SxFcNGZZXUznUSv/J882ZWN
wvrmSvB/zLFH393w+NO5cZ5+hwx1ClS/CuLW0ej4qRGeFD9FD5HDNzMg/E4MDTESe5d1B4D+
hCqrNpaKROdPQoCN6MUsWhjJmsHN1WeyTC/ZD9gYsInGe5e9g9sCRoWd9ZcY8xG4pf1jmPFD
c0ef3/Rl+ho1kZi/J//VudbkPrRAkDqhev+Na28qDbyNU1OAIwBpxgmaMBlwR9FGYQhfipMo
8wR8wpnHy5/7ne/Hhr/69cpxb68dmcOpswuJYEg8Ie895P+58hjdXqrTTer9gfBQY/ZX1/bW
aq90Shrc3LA27rKmdVT0gPvI2W/rR5y+yO3wrdEb7qVuKUqJN3veNnTZQ+HzGfaJv3waq1u+
LhKkPY+6cM9zMYIDoTCCA50CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMV
aHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9y
aXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAw1DyzAJBgUrDgMCGgUA
oIIB9TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzA4MTIw
NjA3MjlaMCMGCSqGSIb3DQEJBDEWBBTonZTTop7/XOt5XprR32EPvMjo1DBsBgkqhkiG9w0B
CQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcN
AwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEE
AYI3EAQxgYMwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5j
YWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZI
hvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAw1DyzCBkwYLKoZIhvcNAQkQAgsxgYOggYAw
eTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIw
IAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBw
b3J0QGNhY2VydC5vcmcCAw1DyzANBgkqhkiG9w0BAQEFAASCAQCLZKDMhQkF7dOtdbkM3MLh
zJz/gp8mbJ9vMKG5Q1pWL5ZX0z9Vc4xIo7ZwCnkIBYsVr4MdZifmXcIuPJsYtgjPVB6OAWDm
kNKLDKCxT6k8vr/ziJ94oTZJzMHPjFPu3IV4lYXoupSKdNWM+kZarsMi33sTSmTiOlKBcuEk
lnkIr+CeqlEW1CSSsuL10vMOJEiDMJuSPz5y6Y7lSO7D2VTTQFMFxpJLUGq3apagOhJ2q8G2
YxDk19BxrX6YoO2iaE+QYD1LKrrmhoYAJ5p6ZAmKXz1YfDInl3m6Zy6y32sL6cDBscQXsY/b
QN0KXSmQk3e1gGsUD5Pqo71ycrEimnJZAAAAAAAA
--------------ms010006050206030408020704--
