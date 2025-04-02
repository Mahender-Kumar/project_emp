import 'package:flutter/material.dart';
import 'package:project_emp/data/models/jobs_model.dart';

class JobSelectionBottomSheet {
  static Future<void> showJobSelectionSheet({
    required BuildContext context,
    required Function(String) onJobSelected, // Callback to handle selection
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            // left: 16,
            // right: 16,
            // bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            // top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: sampleJobs.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final job = sampleJobs[index];
                  return ListTile(
                    title: Text(job.title),
                    onTap: () {
                      // context.read<JobCubit>().selectJob(job);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
