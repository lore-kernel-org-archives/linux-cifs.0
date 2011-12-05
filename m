From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Mon, 5 Dec 2011 11:24:39 -0600
Message-ID: <CADT32e+gb=GME_XDYFk06hD8eTg+fED94QHM3LY3yzJ1Kt1E6g@mail.gmail.com>
References: <4ED2FD48.7060108@gmail.com>
	<CADT32e+RMW_oT=g9OMpy29OHQ731Du7_XaT=xOeMyYGWOofAEg@mail.gmail.com>
	<jbit2d$ikm$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jbit2d$ikm$1@dough.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Dec 5, 2011 at 10:55 AM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 05/12/11 16:00, Shirish Pargaonkar wrote:
>>>
>>>
>>> the following command works from my slackware system:
>>> =A0mount.cifs //server/share /mnt -o guest
>>
>>
>> Would be interesting to compare the tcpdump/wireshark trace
>> for a successful anonymous login from slackware but failing
>> anonymous login from a xubuntu box.
>>
>
> ok, I've attached file generated on slackware, only difference to the
> command above is the mountpoint (/mnt/store).
>
> the xubuntu one, same tcpdump command-line and mount.cifs invokation,=
 was
> posted on 2nd Dec.
>
>
>>
>> Is there something setup in the stanza of this share on the Samba
>> server that is specific to Xubuntu machine/address?
>>
>
> not to my knowledge, NAS has never been set-up in this sense, all def=
aults.
> =A0on the two respective clients I use exact same smb.conf's (except =
hostname)
> but in any case, mount.cifs ignores smb.conf, according to its man pa=
ge.

Looked at the tcpdump.
On the slackware, you are authenticating as user root and not anonymous=
=2E
