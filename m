From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Remove rfc1002 headers from SMB2 responses
Date: Wed,  3 Jan 2018 09:35:22 +1100
Message-ID: <20180102223524.8389-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, all

Please review but do not merge.
This is based on current sfrench/for-next and is the final step
before we can start doing compounding.

The patch will break the soon to be merged SMBD support from Long Li
so do not merge this. I suggest we wait until Long's patches are merged and
I will rebase, and fixup the SMBD parts that this breaks.

The first patch removes the rfc1002 length field from all SMB2 responses.
Unfortunately it is not easy to do this in a set of incremental patches
as opposed to one single big patch since in the demultiplex loop
we can not really distinguish between different response structures
until we have read the full SMB2 header, and in order to read the header
we must know whether there should be a rfc1002 length there or not.
I.e. chicken and egg.

During developmnet of these patches I did have a series that performed
the change one structure at a time but it is very ugly, doing 
memcpy to strip off the header when there should be none
and converting several helper functions to check their char*buf arguments
whether it looked like the buffer started with a rfc1002 header or not.
Very ugly and not I think something we want in the upstream commit history
but if someone really wants to see the "individual change for each response
structure" I could make those intermediate patchsets available.

It works for basic and manual testing. What remains is to ensure that
SMBD is updated to not have to prepend the length field any more
once those patches go in, and also SMB3 encryption.
I have not had a chance to test it so if someone could help here
would be awesome.


The second patch updates the demultiplex loop so that it can handle
compounded responses.
