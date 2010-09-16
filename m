From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 17:50:28 -0500
Message-ID: <AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100916171408.03a0fcd8-8QzAbx0zao2B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 16, 2010 at 4:39 PM,  <starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org> wrote:
> Hello,
>
> Trying out a CIFS mount of a W2K8 x64 file system from CentOS
> 5.5 and running into problems, and trying to figure out how to
> proceed.
>
> I mount up the Windows share, then run a script that expands
> about ten TAR format archives containing a couple of hundred
> files with the 'pax' utility. =A0Then it removes about two dozen
> files. =A0The script is a primitive source-code version extractor.
>
> Unfortunately the resulting tree is quite incorrect. =A0Some of the
> files that should be deleted by the 'rm' commands are not, and
> some of the files that should be there from the expansion are
> missing. =A0The script works fine with EXT2/3/4 and NFSv3 mounts.
>
> So it seems to me CIFS mounts are not ready for use in
> production or development.
>
> Before I give up, is there anything obvious that I'm missing?
> I searched for relevant bugs in Red Hat, Samba and Kernel.org
> bugzillas and didn't find anything that seems to match.
>
> The version mix in use is a little odd. =A0The kernel and
> 'cifs.ko' modules are pure RHEL/CentOS version 2.6.18-194.11.3.el5,

This is quite old kernel, but perhaps it was updated to include more
recent fixes - can you view the version information on the file, ie
the cifs.ko module (you can do this by running modinfo on cifs.ko)


--=20
Thanks,

Steve
