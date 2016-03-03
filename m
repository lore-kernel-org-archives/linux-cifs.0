From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: xfstest groups for network file systems
Date: Thu, 3 Mar 2016 13:34:10 -0600
Message-ID: <CAH2r5mt32xHqjGqjrKg0FnU+Wk3sELPLyoB4KP+WS2P1oe1Leg@mail.gmail.com>
References: <CAH2r5mtMDzqQZ0fyyHSxmyEcwWF+doXO+fPRtAwCgfPf=2ppMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtMDzqQZ0fyyHSxmyEcwWF+doXO+fPRtAwCgfPf=2ppMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

In experimenting with automating tests better for network file systems
(NFS and CIFS/SMB3), I noticed that xfstest doesn't have test groups
that help distinguish a good subset of tests to run over them.  My
goal was to have an easy way to run:

- a quick (under 15 minute) build verification test of SMB3 (and also
similarly for NFSv4.2)
- a full regression test of SMB3 (and also NFSv4.2) that runs all valid tests

The existing test group "quick" has some tests that are quick only for
a local filesystem and can be quite slow when run over a network.
And there are few file system specific test groups (there is one for
udf).

I have a patch that adds a "cifs-quick" test group (can be changed to
"smb3-quick" if anyone prefers that name since our goal is to test the
more important, newer dialects) and a "cifs" (or "cifs-slow" or
"cifs-full").  Similarly I have one for "nfs-quick"

But before I submit there are two obvious questions:
1) Should these test groups (in particular "cifs-quick" and
"nfs-quick") include any tests that we know will fail today? (e.g.
permissions errors that require adding a new feature to the smb3
implementation in the kernel file system, or silly rename problems
that are difficult to work around and have not been addressed in the
kernel clients)

2) Should we create additional test groups by dialect or target server
(e.g. smb3-quick vs. cifs-quick vs. cifs-samba-quick vs. nfsv3-quick
vs. nfsv4.2-quick)?  For example, some testcases will work over CIFS
protocol but not over SMB3? or are valid (or will fail on only one
dialect or for one serrver type e.g. for NFSv4.2 but not for NFSv3).
For example there is one test that fails to Samba server (due to a
negative time error) but works to Windows server targets, and there
are tests which require fallocate so will fail to servers or server fs
that don't implement punch hole, zero range etc.

--
Thanks,

Steve


-- 
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
